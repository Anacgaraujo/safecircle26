import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/person_row.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/application/circle_service.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/presentation/add_participants_screen.dart';
import 'package:safecircle/features/circles/presentation/circle_name_screen.dart';

class CircleDetailScreen extends ConsumerStatefulWidget {
  const CircleDetailScreen({super.key, required this.circle});
  final Circle circle;

  @override
  ConsumerState<CircleDetailScreen> createState() => _CircleDetailScreenState();
}

class _CircleDetailScreenState extends ConsumerState<CircleDetailScreen> {
  Circle get _circle {
    final id = widget.circle.id;
    final live = ref.watch(myCirclesProvider).value;
    if (id == null || live == null) return widget.circle;
    return live.where((c) => c.id == id).firstOrNull ?? widget.circle;
  }

  Future<void> _delete(Circle circle) async {
    final ok = await showScConfirm(
      context,
      title: 'Delete ${circle.name}?',
      body: 'Everyone in this circle stops following your journeys and alerts. '
          'This can’t be undone.',
      confirmLabel: 'Delete circle',
    );
    if (!ok) return;
    if (circle.id != null) {
      await ref.read(circleRepositoryProvider).deleteCircle(circle.id!);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _leave(Circle circle) async {
    final owner = circle.ownerName ?? 'the owner';
    final ok = await showScConfirm(
      context,
      title: 'Leave ${circle.name}?',
      body: "You'll stop following $owner's journeys and alerts, and this circle "
          'stops seeing your location. $owner can invite you again.',
      confirmLabel: 'Leave circle',
      icon: FeatherIcons.logOut,
    );
    if (!ok) return;
    try {
      if (circle.id != null) {
        await ref.read(circleRepositoryProvider).leaveCircle(circle.id!);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) showScToast(context, 'Could not leave the circle. Try again.');
    }
  }

  Future<void> _removeMember(Circle circle, Person member) async {
    final ok = await showScConfirm(
      context,
      title: 'Remove ${member.name}?',
      body: 'They will no longer follow your journeys or receive your alerts.',
      confirmLabel: 'Remove',
      icon: FeatherIcons.userMinus,
    );
    if (!ok || !mounted) return;
    final removal = ref.read(circleServiceProvider).removeMember(circle, member);
    setState(() {});
    try {
      await removal;
    } catch (e) {
      debugPrint('[SafeCircle] removeMember: $e');
      if (mounted) showScToast(context, 'Could not remove the participant. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final circle = _circle;
    final session = ref.watch(sessionProvider);
    final (emoji, text) = circle.parts;
    final isOwner = circle.ownerId == session.uid;
    final people = circle.peopleSeenBy(session.uid, myEmail: session.userEmail);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Row(
                children: [
                  Expanded(child: ScBackButton(label: 'Circles')),
                  if (isOwner) ...[
                    IconButton(
                      onPressed: () => _delete(circle),
                      icon: const Icon(FeatherIcons.trash2, size: 20, color: ScColors.red500),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CircleNameScreen(circle: circle)),
                        );
                        setState(() {});
                      },
                      icon: const Icon(FeatherIcons.edit3, size: 20, color: ScColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 14, 26, 0),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration:
                        BoxDecoration(color: ScColors.brandTint, borderRadius: BorderRadius.circular(18)),
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 30)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ScText.sans(
                                size: 26,
                                weight: FontWeight.w800,
                                color: ScColors.textHeading,
                                height: 30,
                                spacing: -0.5)),
                        const SizedBox(height: 3),
                        Text(
                            '${people.length} ${people.length == 1 ? 'participant' : 'participants'}',
                            style: ScText.sans(size: 13, weight: FontWeight.w600, color: ScColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 12),
              child: const ScSectionLabel('Participants', icon: FeatherIcons.users),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                children: [
                  for (final person in people) ...[
                    PersonRow(
                      person: person,
                      subtitle: person.uid != null && person.uid == circle.ownerId
                          ? 'Circle owner'
                          : null,
                      onDelete: isOwner ? () => _removeMember(circle, person) : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
              child: Column(
                children: [
                  if (isOwner) ...[
                    ScButton(
                      label: 'Add more participants',
                      leftIcon: FeatherIcons.userPlus,
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddParticipantsScreen(draft: circle, isExisting: true),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _delete(circle),
                      icon: const Icon(FeatherIcons.trash2, size: 18, color: ScColors.red500),
                      label: Text('Delete this circle',
                          style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.red500)),
                    ),
                  ] else
                    TextButton.icon(
                      onPressed: () => _leave(circle),
                      icon: const Icon(FeatherIcons.logOut, size: 18, color: ScColors.red500),
                      label: Text('Leave this circle',
                          style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.red500)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
