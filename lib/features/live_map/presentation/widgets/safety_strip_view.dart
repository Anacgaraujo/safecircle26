import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/clock.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/alerts/presentation/alert_detail_screen.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/journeys/presentation/journeys_screen.dart';
import 'package:safecircle/features/live_map/domain/map_rules.dart';
import 'package:safecircle/features/live_map/presentation/widgets/map_controls.dart';

class SafetyStripView extends ConsumerWidget {
  const SafetyStripView({super.key, this.onGoCircles});
  final VoidCallback? onGoCircles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strip = SafetyStrip.of(
      ref.watch(incomingAlertsProvider).value ?? const [],
      ref.watch(friendsJourneysProvider).value ?? const [],
      ref.now(const Duration(seconds: 30)),
    );
    if (strip == null) return const SizedBox.shrink();
    final alert = strip.alert;
    return MapStrip(
      color: switch (strip.level) {
        SafetyLevel.alert => ScColors.brand,
        SafetyLevel.late => ScColors.red500,
        SafetyLevel.due => ScColors.amber800,
        SafetyLevel.calm => ScColors.textHeading,
      },
      icon: switch (strip.level) {
        SafetyLevel.alert =>
          alert?.type == 'panic' ? FeatherIcons.shield : FeatherIcons.alertTriangle,
        SafetyLevel.due => FeatherIcons.clock,
        _ => FeatherIcons.navigation,
      },
      label: strip.label,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => alert != null
              ? AlertDetailScreen(alert: alert)
              : JourneysScreen(onGoCircles: onGoCircles))),
    );
  }
}
