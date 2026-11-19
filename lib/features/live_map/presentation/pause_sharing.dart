import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/pin_prompt.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/journeys/domain/pin_check.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/l10n/l10n.dart';

/// Pauses live sharing after the safety PIN. The panic PIN looks the same on
/// this phone but keeps sharing and silently alerts the circle. Used from the
/// map card and from the membership screen, so the panic PIN works with or
/// without a membership.
Future<void> pauseSharingWithPin(BuildContext context, WidgetRef ref) async {
  final sharing = ref.read(liveSharingProvider.notifier);
  final session = ref.read(sessionProvider);
  final hasPins = session.safetyPin.isNotEmpty || session.panicPin.isNotEmpty;
  final PinResult? result;
  if (hasPins) {
    result = await askForPin(context,
        title: context.l10n.pauseSharingQuestion,
        body: '${context.l10n.pauseSharingBody} ${context.l10n.enterPinToPause}');
  } else {
    final ok = await showScConfirm(
      context,
      title: context.l10n.pauseSharingQuestion,
      body: context.l10n.pauseSharingBody,
      confirmLabel: context.l10n.pause,
      icon: FeatherIcons.pause,
    );
    result = ok ? PinResult.safety : null;
  }
  if (result == null || result == PinResult.wrong) return;
  if (result == PinResult.panic) {
    sharing.pauseUnderDuress();
    final alerts = ref.read(alertRepositoryProvider);
    LocationService.instance
        .getCurrent()
        .then((loc) => alerts.fireAlert(type: 'panic', location: loc))
        .catchError((Object e) {
      debugPrint('[SafeCircle] duress alert: $e');
      return 0;
    });
  } else {
    await sharing.pause();
  }
  if (context.mounted) showScToast(context, context.l10n.sharingPaused);
}
