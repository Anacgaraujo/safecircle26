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
import 'package:safecircle/l10n/l10n.dart';

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
      title: context.l10n.deleteCircleQuestion(circle.name),
      body: context.l10n.deleteCircleBody,
      confirmLabel: context.l10n.deleteCircle,
    );
    if (!ok) return;
    if (circle.id != null) {
      await ref.read(circleRepositoryProvider).deleteCircle(circle.id!);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _leave(Circle circle) async {
    final owner = circle.ownerName ?? context.l10n.theOwner;
    final ok = await showScConfirm(
      context,
      title: context.l10n.leaveCircleQuestion(circle.name),
      body: context.l10n.leaveCircleBody(owner),
      confirmLabel: context.l10n.leaveCircle,
      icon: FeatherIcons.logOut,
    );
    if (!ok) return;
    try {
      if (circle.id != null) {
        await ref.read(circleRepositoryProvider).leaveCircle(circle.id!);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) showScToast(context, context.l10n.couldNotLeaveCircle);
    }
  }

  final _resending = <Person>{};

  Future<void> _resend(Circle circle, Person member) async {
    final phone = member.digits.isNotEmpty ? member.fullPhone : null;
    final ok = await showScConfirm(
      context,
      title: context.l10n.resendInvitationQuestion(member.firstName),
      body: phone != null
          ? context.l10n.resendInvitationTextBody(phone)
          : context.l10n.resendInvitationAppBody,
      confirmLabel: context.l10n.resend,
      icon: FeatherIcons.send,
    );
    if (!ok || !mounted) return;
    setState(() => _resending.add(member));
    try {
      final result = await ref.read(circleServiceProvider).resendInvitation(circle, member);
      if (mounted) showScToast(context, result.message(member.firstName));
    } catch (e) {
      debugPrint('[SafeCircle] resendInvitation: $e');
      if (mounted) showScToast(context, context.l10n.couldNotResendInvitation);
    } finally {
      if (mounted) setState(() => _resending.remove(member));
    }
  }

  Future<void> _removeMember(Circle circle, Person member) async {
    final ok = await showScConfirm(
      context,
      title: context.l10n.removePersonQuestion(member.name),
      body: context.l10n.removePersonBody,
      confirmLabel: context.l10n.remove,
      icon: FeatherIcons.userMinus,
    );
    if (!ok || !mounted) return;
    final removal = ref.read(circleServiceProvider).removeMember(circle, member);
    setState(() {});
    try {
      await removal;
    } catch (e) {
      debugPrint('[SafeCircle] removeMember: $e');
      if (mounted) showScToast(context, context.l10n.couldNotRemoveParticipant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final circle = _circle;
    final session = ref.watch(sessionProvider);
    final (emoji, text) = circle.parts;
    final isOwner = circle.ownerId == session.uid;
    final people = circle.peopleSeenBy(session.uid, myEmail: session.userEmail);
    final inviteStatus = isOwner && circle.id != null
        ? ref.watch(sentInviteStatusProvider(circle.id!)).value ?? const <String, String>{}
        : const <String, String>{};
    bool canResend(Person p) =>
        isOwner &&
        p.uid != circle.ownerId &&
        inviteStatus[(p.email ?? '').toLowerCase()] != 'accepted' &&
        ((p.email ?? '').isNotEmpty || p.digits.isNotEmpty);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Row(
                children: [
                  Expanded(child: ScBackButton(label: context.l10n.tabCircles)),
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
                            context.l10n.participantCount(people.length),
                            style: ScText.sans(size: 13, weight: FontWeight.w600, color: ScColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 12),
              child: ScSectionLabel(context.l10n.participants, icon: FeatherIcons.users),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                children: [
                  for (final person in people) ...[
                    PersonRow(
                      person: person,
                      subtitle: person.uid != null && person.uid == circle.ownerId
                          ? context.l10n.circleOwner
                          : null,
                      onResend: canResend(person) && !_resending.contains(person)
                          ? () => _resend(circle, person)
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
                      label: context.l10n.addMoreParticipants,
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
                      label: Text(context.l10n.deleteThisCircle,
                          style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.red500)),
                    ),
                  ] else
                    TextButton.icon(
                      onPressed: () => _leave(circle),
                      icon: const Icon(FeatherIcons.logOut, size: 18, color: ScColors.red500),
                      label: Text(context.l10n.leaveThisCircle,
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
