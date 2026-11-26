import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/widgets/async_view.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/places/application/place_service.dart';
import 'package:safecircle/features/places/data/place_repository.dart';
import 'package:safecircle/features/places/presentation/place_icons.dart';
import 'package:safecircle/features/places/presentation/place_sheet.dart';
import 'package:safecircle/l10n/l10n.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key, required this.circle});

  /// The circle on the map; new places start in it.
  final Circle? circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circles = [
      for (final c in ref.watch(myCirclesProvider).value ?? const <Circle>[])
        if (c.id != null) c,
    ];
    Circle? circleOf(Place p) => circles.where((c) => c.id == p.circleId).firstOrNull;
    final start = circle ?? circles.firstOrNull;
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(children: [ScBackButton(onTap: () => Navigator.of(context).pop())]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.places,
                      style: ScText.sans(
                          size: 26,
                          weight: FontWeight.w800,
                          color: ScColors.textHeading,
                          spacing: -.6)),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.placesHint,
                    style: ScText.sans(
                        size: 14, weight: FontWeight.w500, color: ScColors.textSecondary, height: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScAsyncView(
                value: ref.watch(placesProvider),
                data: (all) {
                  // Every place in the user's circles, each labelled with its circle.
                  final places = all;
                  if (places.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(
                          context.l10n.noPlacesYet,
                          textAlign: TextAlign.center,
                          style: ScText.sans(
                              size: 14,
                              weight: FontWeight.w500,
                              color: ScColors.textMuted,
                              height: 20),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    itemCount: places.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _PlaceCard(
                      place: places[i],
                      circle: circleOf(places[i]),
                      showCircle: circles.length > 1,
                      onEdit: () => _openSheet(context, circleOf(places[i]) ?? start, places[i]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: ScButton(
                label: context.l10n.addPlace,
                leftIcon: FeatherIcons.plus,
                onPressed: start == null ? null : () => _openSheet(context, start, null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSheet(BuildContext context, Circle? circle, Place? existing) {
    if (circle == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ScColors.canvas,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (_) => PlaceSheet(circle: circle, existing: existing),
    );
  }
}

class _PlaceCard extends ConsumerWidget {
  const _PlaceCard(
      {required this.place, required this.circle, required this.showCircle, required this.onEdit});
  final Place place;
  final Circle? circle;
  final bool showCircle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watched = circle == null
        ? const <Person>[]
        : circle!.members
            .where((m) => place.memberIds.isEmpty || place.memberIds.contains(m.uid))
            .take(4)
            .toList();

    return ScPressable(
      pressedScale: .99,
      onTap: onEdit,
      child: ScCard(
        radius: 18,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: ScColors.brandTint, borderRadius: BorderRadius.circular(12)),
                  child: Icon(placeIcon(place.icon), size: 20, color: ScColors.brand),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ScText.sans(size: 16, weight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(
                          '${place.address.isEmpty ? context.l10n.savedLocation : place.address} · ${scFeet(place.radiusM)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ScText.sans(
                              size: 12.5, weight: FontWeight.w600, color: ScColors.textMuted)),
                    ],
                  ),
                ),
                Switch(
                  value: place.enabled,
                  activeThumbColor: ScColors.brand,
                  onChanged: (v) async {
                    try {
                      await ref.read(placeServiceProvider).setEnabled(place, circle, v);
                    } catch (e) {
                      debugPrint('[SafeCircle] toggle place: $e');
                      if (context.mounted) showScToast(context, context.l10n.couldNotUpdatePlace);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: ScColors.borderHairline),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                      showCircle && circle != null
                          ? '${place.ruleLabel} · ${circle!.name}'
                          : place.ruleLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ScText.sans(
                          size: 12.5, weight: FontWeight.w700, color: ScColors.textSecondary)),
                ),
                for (final m in watched)
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ScAvatar(image: m.image, name: m.name, size: 24),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
