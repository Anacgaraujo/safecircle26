import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/contacts/presentation/contacts_screen.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/presentation/journey_flow_screen.dart';
import 'package:safecircle/features/membership/application/membership_controller.dart';
import 'package:safecircle/features/membership/domain/membership.dart';
import 'package:safecircle/features/membership/presentation/membership_paywall.dart';
import 'package:safecircle/features/profile/application/profile_service.dart';
import 'package:safecircle/features/profile/domain/profile_rules.dart';
import 'package:safecircle/features/profile/presentation/profile_form_screen.dart';
import 'package:safecircle/features/profile/presentation/settings_screen.dart';
import 'package:safecircle/features/profile/presentation/widgets/profile_ui.dart';
import 'package:safecircle/l10n/l10n.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.onGoCircles});

  final VoidCallback? onGoCircles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildBody(
      context,
      ref,
      ref.watch(sessionChangesProvider),
      ref.watch(contactsProvider).value?.length ?? 0,
      ref.watch(myCirclesProvider).value ?? const <Circle>[],
      ref.watch(journeyHistoryProvider).value?.length ?? 0,
    );
  }

  /// The store's own subscription page, where it can be changed or canceled.
  static void _manageSubscription() {
    final url = defaultTargetPlatform == TargetPlatform.android
        ? 'https://play.google.com/store/account/subscriptions'
        : 'https://apps.apple.com/account/subscriptions';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, Session app, int ccount,
      List<Circle> circles, int historyCount) {
    final membership = ref.watch(membershipProvider);
    final items = [
          (
            FeatherIcons.edit3,
            context.l10n.editProfile,
            context.l10n.editProfileSub,
            () => pushScreen(context, const ProfileFormScreen(kind: ProfileFormKind.editProfile)),
          ),
          (
            FeatherIcons.users,
            context.l10n.myEmergencyContacts,
            context.l10n.peopleWillBeAlerted(ccount),
            () => pushScreen(context, const EmergencyContactsScreen()),
          ),
          (
            null,
            context.l10n.myCircles,
            circlesSummary(circles),
            onGoCircles ?? () {},
          ),
          (
            FeatherIcons.clock,
            context.l10n.journeyHistory,
            context.l10n.completedJourneys(historyCount),
            () => requireMembership(
                context, ref, () => pushScreen(context, const JourneyFlow(startAtHistory: true))),
          ),
          if (membership != MembershipStatus.unavailable)
            (
              FeatherIcons.star,
              context.l10n.membershipLabel,
              membership == MembershipStatus.inactive
                  ? context.l10n.membershipInactiveSub
                  : context.l10n.membershipActiveSub,
              () => membership == MembershipStatus.inactive
                  ? pushScreen(context, const MembershipScreen())
                  : _manageSubscription(),
            ),
        ];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.l10n.profile, style: ScText.title()),
                  ScCircleIconButton(
                    icon: FeatherIcons.settings,
                    onTap: () => pushScreen(context, const SettingsScreen()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  const SizedBox(height: 22),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ScColors.surfaceCard, width: 4),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .14), offset: const Offset(0, 8), blurRadius: 24)],
                          ),
                          child: ScAvatar(
                              image: app.userPhoto,
                              name: app.userName.isEmpty ? context.l10n.me : app.userName,
                              size: 104),
                        ),
                        Positioned(
                          right: -2,
                          bottom: 2,
                          child: ScPressable(
                            pressedScale: .94,
                            onTap: () async {
                              try {
                                final picked = await ImagePicker().pickImage(
                                    source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
                                if (picked == null) return;
                                await ref.read(profileServiceProvider).updatePhoto(picked.path);
                              } catch (_) {
                                if (context.mounted) {
                                  showScToast(context, context.l10n.couldNotUpdatePhoto);
                                }
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: ScColors.brand,
                                shape: BoxShape.circle,
                                border: Border.all(color: ScColors.canvas, width: 3),
                                boxShadow: ScShadows.brand,
                              ),
                              child: const Icon(FeatherIcons.edit3, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(app.userName.isEmpty ? context.l10n.me : app.userName,
                        style: ScText.sans(size: 22, weight: FontWeight.w800, color: ScColors.textHeading, spacing: -.3)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FeatherIcons.mail, size: 14, color: ScColors.textSubtle),
                        const SizedBox(width: 6),
                        Text(app.userEmail,
                            style: ScText.sans(size: 14, weight: FontWeight.w600, color: ScColors.textSubtle)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    decoration: BoxDecoration(
                      color: ScColors.surfaceCard,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: ScShadows.card,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (var i = 0; i < items.length; i++)
                          _MenuRow(
                            icon: items[i].$1,
                            label: items[i].$2,
                            sub: items[i].$3,
                            onTap: items[i].$4,
                            topBorder: i > 0,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({this.icon, required this.label, required this.sub, required this.onTap, this.topBorder = false});
  final IconData? icon;
  final String label;
  final String sub;
  final VoidCallback onTap;
  final bool topBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          border: topBorder ? const Border(top: BorderSide(color: ScColors.borderHairline)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: profileTileBg, borderRadius: BorderRadius.circular(13)),
              alignment: Alignment.center,
              child: icon == null
                  ? const CirclesIcon(size: 21, color: ScColors.purple700)
                  : Icon(icon, size: 21, color: ScColors.purple700),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: ScText.sans(size: 15.5, weight: FontWeight.w700, color: ScColors.textHeading)),
                  const SizedBox(height: 1),
                  Text(sub, style: ScText.sans(size: 12.5, weight: FontWeight.w500, color: ScColors.textMuted)),
                ],
              ),
            ),
            const Icon(FeatherIcons.chevronRight, size: 20, color: ScColors.brand),
          ],
        ),
      ),
    );
  }
}
