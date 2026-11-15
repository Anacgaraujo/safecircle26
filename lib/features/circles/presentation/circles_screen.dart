import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_bottom_nav.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/domain/circle_invite.dart';
import 'package:safecircle/features/circles/presentation/circle_detail_screen.dart';
import 'package:safecircle/features/circles/presentation/circle_name_screen.dart';
import 'package:safecircle/features/circles/presentation/invite_received_screen.dart';

class CirclesScreen extends ConsumerWidget {
  const CirclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circlesAsync = ref.watch(myCirclesProvider);
    final invitesAsync = ref.watch(pendingInvitesProvider);
    final invites = invitesAsync.value ?? const <CircleInvite>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 20, 0),
          child: Row(
            children: [
              Expanded(child: Text('My circles', style: ScText.title())),
              const CirclesIcon(size: 24, color: ScColors.brand),
            ],
          ),
        ),
        Expanded(
          child: invitesAsync.hasError
              ? ScStreamError(error: invitesAsync.error!)
              : ScAsyncView(
                  value: circlesAsync,
                  data: (circles) => (circles.isEmpty && invites.isEmpty)
                      ? const Center(child: _CirclesEmpty())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
                          children: [
                            for (final invite in invites) ...[
                              _InviteCard(
                                invite: invite,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => InviteReceivedScreen(invite: invite)),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (invites.isNotEmpty) const SizedBox(height: 8),
                            if (circles.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: _CirclesEmpty(),
                              )
                            else
                              for (final c in circles) ...[
                                _CircleCard(circle: c),
                                const SizedBox(height: 12),
                              ],
                          ],
                        ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
          child: ScButton(
            label: 'Create new circle',
            leftIcon: FeatherIcons.plus,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CircleNameScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _CirclesEmpty extends StatelessWidget {
  const _CirclesEmpty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FeatherIcons.frown, size: 72, color: ScColors.textMuted),
          const SizedBox(height: 14),
          Text("You don't have any circle created",
              textAlign: TextAlign.center,
              style: ScText.sans(size: 17, weight: FontWeight.w700, color: ScColors.textSecondary)),
          const SizedBox(height: 6),
          SizedBox(
            width: 250,
            child: Text(
              'Create a circle to gather the people you trust and share your journeys with them.',
              textAlign: TextAlign.center,
              style: ScText.sans(size: 14, weight: FontWeight.w500, color: ScColors.textMuted, height: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({required this.invite, required this.onTap});
  final CircleInvite invite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      onTap: onTap,
      child: ScCard(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            ScAvatar(name: invite.senderName, size: 42),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New circle invite', style: ScText.sans(size: 14.5, weight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('${invite.senderFirstName} invited you to ${invite.circleName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(
                          size: 13, weight: FontWeight.w500, color: ScColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(color: ScColors.brand, borderRadius: BorderRadius.circular(999)),
              child: Text('NEW',
                  style: ScText.sans(size: 11, weight: FontWeight.w700, color: Colors.white, spacing: .4)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleCard extends ConsumerWidget {
  const _CircleCard({required this.circle});
  final Circle circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (emoji, text) = circle.parts;
    final session = ref.watch(sessionProvider);
    final people = circle.peopleSeenBy(session.uid, myEmail: session.userEmail);
    return ScPressable(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CircleDetailScreen(circle: circle)),
      ),
      child: ScCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: ScColors.brandTint, borderRadius: BorderRadius.circular(14)),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: ScText.sans(size: 16, weight: FontWeight.w800, color: ScColors.textHeading)),
                  const SizedBox(height: 2),
                  Text('${people.length} ${people.length == 1 ? 'member' : 'members'}',
                      style: ScText.sans(size: 13, weight: FontWeight.w500, color: ScColors.textMuted)),
                ],
              ),
            ),
            SizedBox(
              height: 32,
              width: 32.0 + (people.length.clamp(0, 3) - 1).clamp(0, 2) * 22,
              child: Stack(
                children: [
                  for (var i = 0; i < people.length.clamp(0, 3); i++)
                    Positioned(
                      left: i * 22,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ScColors.surfaceCard, width: 2),
                        ),
                        child: ScAvatar(
                            image: people[i].image, name: people[i].name, size: 28),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(FeatherIcons.chevronRight, size: 22, color: ScColors.brand),
          ],
        ),
      ),
    );
  }
}
