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
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/contacts/presentation/contacts_screen.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';

class PickCircleStep extends ConsumerWidget {
  const PickCircleStep({
    super.key,
    required this.checkIns,
    required this.selectedCircleId,
    required this.starting,
    required this.onSelect,
    required this.onBack,
    required this.onStart,
  });

  final List<CheckIn> checkIns;
  final String? selectedCircleId;
  final bool starting;
  final ValueChanged<Circle> onSelect;
  final VoidCallback onBack;
  final ValueChanged<Circle> onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final circlesAsync = ref.watch(myCirclesProvider);
    final contactsAsync = ref.watch(contactsProvider);
    final loaded = circlesAsync.hasValue && contactsAsync.hasValue;
    final circles = circlesAsync.value ?? const <Circle>[];
    final selected = circles.where((c) => c.id == selectedCircleId).firstOrNull ??
        circles.firstOrNull;

    final lowContacts = (contactsAsync.value?.length ?? 2) < 2;
    final noCircles = loaded && circles.isEmpty;
    final noWatchers =
        selected != null && selected.memberIds.where((id) => id != session.uid).isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
          child: ScBackButton(onTap: onBack),
        ),
        Expanded(
          child: ScAsyncView(
            value: circlesAsync,
            data: (_) => ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Who's watching?", style: ScText.headline()),
                      const SizedBox(height: 6),
                      Text('Pick the circle that monitors this journey.', style: ScText.sub()),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                if (noCircles)
                  const _NoCircleNotice()
                else
                  for (final c in circles) ...[
                    _CircleChoice(
                      circle: c,
                      selected: c == selected,
                      watching: c.peopleSeenBy(session.uid, myEmail: session.userEmail).length,
                      onTap: () => onSelect(c),
                    ),
                    const SizedBox(height: 12),
                  ],
                if (noWatchers)
                  Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: ScColors.amber100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(FeatherIcons.userX, size: 20, color: ScColors.amber800),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Nobody in this circle has accepted the invite yet, so no one could see this journey. Wait for a member to accept before starting.",
                            style: ScText.sans(
                                size: 13.5, weight: FontWeight.w600, color: ScColors.amber800, height: 19),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (lowContacts)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: ScColors.red50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ScColors.brand.withValues(alpha: .25)),
                    ),
                    child: Row(
                      children: [
                        const Icon(FeatherIcons.alertCircle, size: 20, color: ScColors.brand),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Add 2 emergency contacts before starting',
                              style: ScText.sans(
                                  size: 13.5,
                                  weight: FontWeight.w600,
                                  color: ScColors.magenta600,
                                  height: 19)),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                                color: ScColors.brand, borderRadius: BorderRadius.circular(999)),
                            child: Text('Add',
                                style: ScText.sans(size: 12, weight: FontWeight.w700, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 22),
                ScCard(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SCHEDULE', style: ScText.micro()),
                      const SizedBox(height: 12),
                      for (final c in checkIns) ...[
                        Row(
                          children: [
                            Container(
                                width: 8,
                                height: 8,
                                decoration:
                                    const BoxDecoration(color: ScColors.brand, shape: BoxShape.circle)),
                            const SizedBox(width: 11),
                            Expanded(
                                child: Text(c.label, style: ScText.sans(size: 14, weight: FontWeight.w600))),
                            Text(c.time,
                                style: ScText.mono(
                                    size: 14, weight: FontWeight.w600, color: ScColors.textSecondary)),
                          ],
                        ),
                        if (c != checkIns.last) const SizedBox(height: 11),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // With no circle, JourneyFlow shows the tab bar here instead.
        if (!noCircles)
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
            child: ScButton(
              label: starting ? 'Starting…' : 'Start journey',
              leftIcon: starting ? null : FeatherIcons.navigation,
              onPressed: !loaded || selected == null || lowContacts || noWatchers || starting
                  ? null
                  : () => onStart(selected),
            ),
          ),
      ],
    );
  }
}

/// Tells the user to create a circle, showing the Circles tab as it appears
/// in the tab bar below so it's obvious where to go.
class _NoCircleNotice extends StatelessWidget {
  const _NoCircleNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ScColors.borderDefault, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            decoration: BoxDecoration(color: ScColors.brandTint, borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CirclesIcon(size: 28, color: ScColors.brand),
                const SizedBox(height: 4),
                Text('Circles',
                    style: ScText.sans(size: 11, weight: FontWeight.w800, color: ScColors.brand, spacing: .2)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'You need a circle first. Tap the Circles tab below to create one.',
            textAlign: TextAlign.center,
            style: ScText.sans(size: 14, weight: FontWeight.w500, color: ScColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _CircleChoice extends StatelessWidget {
  const _CircleChoice({
    required this.circle,
    required this.selected,
    required this.watching,
    required this.onTap,
  });

  final Circle circle;
  final bool selected;

  final int watching;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (emoji, _) = circle.parts;
    return ScPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ScColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: ScShadows.card,
          border: selected ? Border.all(color: ScColors.brand, width: 1.5) : null,
        ),
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
                  Text(circle.name,
                      style: ScText.sans(size: 16, weight: FontWeight.w800, color: ScColors.textHeading)),
                  const SizedBox(height: 2),
                  Text('$watching ${watching == 1 ? 'person' : 'people'} watching',
                      style: ScText.sans(size: 13, weight: FontWeight.w500, color: ScColors.textMuted)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? ScColors.brand : Colors.transparent,
                shape: BoxShape.circle,
                border: selected ? null : Border.all(color: ScColors.borderDefault, width: 2),
              ),
              child: selected ? const Icon(FeatherIcons.check, size: 15, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
