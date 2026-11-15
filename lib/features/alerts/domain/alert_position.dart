import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';

class AlertPosition {
  factory AlertPosition(SafetyAlert alert, MemberStatus? live, DateTime now) {
    final isLive = live != null && live.sharing && live.hasPosition && !live.isStale(now);
    if (!isLive) return AlertPosition._(alert.lat, alert.lng, alert.location, false);
    return AlertPosition._(
        live.lat, live.lng, live.place.isNotEmpty ? live.place : alert.location, true);
  }

  AlertPosition._(this.lat, this.lng, this.place, this.isLive);

  final double? lat;
  final double? lng;
  final String place;
  final bool isLive;
}
