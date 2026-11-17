import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/l10n/l10n.dart';

class InviteReceivedScreen extends ConsumerStatefulWidget {
  const InviteReceivedScreen({super.key, required this.invite});
  final CircleInvite invite;

  @override
  ConsumerState<InviteReceivedScreen> createState() => _InviteReceivedScreenState();
}

class _InviteReceivedScreenState extends ConsumerState<InviteReceivedScreen> {
  bool _busy = false;

  Future<void> _accept() async {
    setState(() => _busy = true);
    try {
      await ref.read(circleRepositoryProvider).acceptInvite(widget.invite);
      if (mounted) await ensureAlertNotifications(context);
      if (mounted) await startLiveSharingByDefault(context);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('[SafeCircle] acceptInvite: $e');
      if (mounted) {
        showScToast(
            context,
            e.toString().contains('permission-denied')
                ? context.l10n.couldNotJoinNoAccess(widget.invite.senderFirstName)
                : context.l10n.couldNotAcceptInvite);
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _decline() async {
    await ref.read(circleRepositoryProvider).declineInvite(widget.invite.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final invite = widget.invite;
    final fromFirst = invite.senderFirstName;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ScAvatar(name: invite.senderName, size: 96, ring: ScAvatarRing.brand),
                    Positioned(
                      right: -6,
                      bottom: -4,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: ScColors.brand,
                          shape: BoxShape.circle,
                          border: Border.all(color: ScColors.canvas, width: 3),
                          boxShadow: ScShadows.brand,
                        ),
                        child: const Center(child: CirclesIcon(size: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(context.l10n.circleInviteEyebrow,
                  textAlign: TextAlign.center,
                  style: ScText.sans(size: 12, weight: FontWeight.w700, color: ScColors.brand, spacing: .9)),
              const SizedBox(height: 10),
              Text(context.l10n.addedYouToCircle(fromFirst, invite.circleName),
                  textAlign: TextAlign.center,
                  style: ScText.sans(
                      size: 26,
                      weight: FontWeight.w800,
                      color: ScColors.textHeading,
                      height: 33,
                      spacing: -0.5)),
              const SizedBox(height: 14),
              Text(
                context.l10n.joinHint(fromFirst),
                textAlign: TextAlign.center,
                style: ScText.sans(size: 14.5, weight: FontWeight.w500, color: ScColors.textSubtle, height: 22),
              ),
              const SizedBox(height: 34),
              ScButton(
                label: _busy ? context.l10n.joining : context.l10n.accept,
                leftIcon: _busy ? null : FeatherIcons.check,
                onPressed: _busy ? null : _accept,
              ),
              const SizedBox(height: 12),
              ScButton(
                label: context.l10n.decline,
                variant: ScButtonVariant.ghost,
                onPressed: _busy ? null : _decline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
