import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/presentation/pause_sharing.dart';
import 'package:safecircle/features/membership/application/membership_controller.dart';
import 'package:safecircle/features/membership/domain/membership.dart';
import 'package:safecircle/features/profile/presentation/legal_doc_screen.dart';
import 'package:safecircle/l10n/l10n.dart';

/// Runs [action] for members; everyone else gets the membership screen.
void requireMembership(BuildContext context, WidgetRef ref, VoidCallback action) {
  if (ref.read(membershipProvider).hasAccess) {
    action();
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MembershipScreen()));
  }
}

/// The paywall as its own screen (opened from a locked button).
class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Close once the membership is active.
    ref.listen(membershipProvider, (_, next) {
      if (next.hasAccess && Navigator.of(context).canPop()) Navigator.of(context).pop();
    });
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
              child: ScBackButton(),
            ),
            const Expanded(child: MembershipPaywall()),
          ],
        ),
      ),
    );
  }
}

/// What a user without a membership sees in place of the locked tabs.
/// SOS (and the panic PIN for pausing sharing) stay usable without one.
class MembershipPaywall extends ConsumerStatefulWidget {
  const MembershipPaywall({super.key, this.onOpenSos});

  /// Shows the Emergency tab. Null where that isn't possible.
  final VoidCallback? onOpenSos;

  @override
  ConsumerState<MembershipPaywall> createState() => _MembershipPaywallState();
}

class _MembershipPaywallState extends ConsumerState<MembershipPaywall> {
  bool _busy = false;

  Future<void> _run(Future<PurchaseOutcome> Function(MembershipController) action) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = context.l10n;
    final outcome = await action(ref.read(membershipProvider.notifier));
    if (!mounted) return;
    setState(() => _busy = false);
    final message = switch (outcome) {
      PurchaseOutcome.subscribed => l10n.membershipWelcome,
      PurchaseOutcome.nothingToRestore => l10n.membershipNothingToRestore,
      PurchaseOutcome.failed => l10n.membershipPurchaseFailed,
      PurchaseOutcome.cancelled => null,
    };
    if (message != null) showScToast(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final plan = ref.watch(membershipPlanProvider);
    final sharing = ref.watch(liveSharingProvider);
    final store = defaultTargetPlatform == TargetPlatform.android
        ? l10n.membershipStoreGoogle
        : l10n.membershipStoreApple;

    return ListView(
      padding: const EdgeInsets.fromLTRB(26, 18, 26, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ScColors.red50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.membershipSosFree,
                  style: ScText.sans(size: 13.5, weight: FontWeight.w700, color: ScColors.textHeading, height: 19)),
              if (widget.onOpenSos != null) ...[
                const SizedBox(height: 10),
                ScButton(
                  label: l10n.membershipOpenSos,
                  variant: ScButtonVariant.danger,
                  leftIcon: FeatherIcons.alertTriangle,
                  height: 46,
                  onPressed: widget.onOpenSos,
                ),
              ],
              if (sharing) ...[
                const SizedBox(height: 4),
                ScButton(
                  label: l10n.membershipPauseSharing,
                  variant: ScButtonVariant.link,
                  onPressed: () => pauseSharingWithPin(context, ref),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        Center(child: Image.asset('assets/images/logo.png', height: 64)),
        const SizedBox(height: 20),
        Text(l10n.membershipTitle, textAlign: TextAlign.center, style: ScText.headline()),
        const SizedBox(height: 8),
        Text(l10n.membershipSubtitle, textAlign: TextAlign.center, style: ScText.sub()),
        const SizedBox(height: 22),
        for (final (icon, text) in [
          (FeatherIcons.mapPin, l10n.membershipPerkMap),
          (FeatherIcons.navigation, l10n.membershipPerkJourneys),
          (FeatherIcons.users, l10n.membershipPerkCircles),
          (FeatherIcons.bell, l10n.membershipPerkAlerts),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: ScColors.brandTint, borderRadius: BorderRadius.circular(11)),
                  child: Icon(icon, size: 18, color: ScColors.brand),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(text,
                      style: ScText.sans(size: 14.5, weight: FontWeight.w600, color: ScColors.textHeading)),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        ...switch (plan) {
          AsyncData(value: final p?) => [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: ScColors.surfaceCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ScColors.brand, width: 1.5),
                  boxShadow: ScShadows.card,
                ),
                child: Column(
                  children: [
                    Text(
                      p.hasFreeTrial ? l10n.membershipTrialPrice(p.trialDays, p.price) : l10n.membershipPrice(p.price),
                      key: const ValueKey('membership-price'),
                      textAlign: TextAlign.center,
                      style: ScText.sans(size: 17, weight: FontWeight.w800, color: ScColors.textHeading),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.membershipCancelAnytime, textAlign: TextAlign.center, style: ScText.micro()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ScButton(
                label: _busy
                    ? l10n.membershipWorking
                    : (p.hasFreeTrial ? l10n.membershipStartTrial : l10n.membershipSubscribe),
                onPressed: _busy ? null : () => _run((c) => c.subscribe()),
              ),
              const SizedBox(height: 12),
              Text(
                p.hasFreeTrial
                    ? l10n.membershipFinePrintTrial(store, p.trialDays)
                    : l10n.membershipFinePrint(store),
                textAlign: TextAlign.center,
                style: ScText.sans(size: 11.5, weight: FontWeight.w500, color: ScColors.textMuted, height: 16),
              ),
            ],
          AsyncLoading() => [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: ScColors.brand),
                ),
              ),
            ],
          _ => [
              Text(l10n.membershipUnavailable, textAlign: TextAlign.center, style: ScText.sub()),
              const SizedBox(height: 12),
              ScButton(
                label: l10n.tryAgain,
                variant: ScButtonVariant.secondary,
                onPressed: () => ref.invalidate(membershipPlanProvider),
              ),
            ],
        },
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ScButton(
              label: l10n.membershipRestore,
              variant: ScButtonVariant.link,
              fullWidth: false,
              onPressed: _busy ? null : () => _run((c) => c.restore()),
            ),
            ScButton(
              label: l10n.termsOfService,
              variant: ScButtonVariant.link,
              fullWidth: false,
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LegalDocScreen(isTerms: true))),
            ),
            ScButton(
              label: l10n.privacyPolicy,
              variant: ScButtonVariant.link,
              fullWidth: false,
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LegalDocScreen(isTerms: false))),
            ),
          ],
        ),
      ],
    );
  }
}
