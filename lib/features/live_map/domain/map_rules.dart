import 'package:latlong2/latlong.dart' hide Circle;

import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/l10n/l10n.dart';

List<MemberStatus> visibleMembers(List<MemberStatus> all, Circle? circle, String me) {
  final ids = circle?.memberIds ?? const <String>[];
  return all
      .where((s) => s.uid == me || ids.contains(s.uid))
      .where((s) => s.sharing && s.hasPosition)
      .toList()
    ..sort((a, b) {
      if (a.uid == me) return 1;
      if (b.uid == me) return -1;
      return a.name.compareTo(b.name);
    });
}

String? phoneOfMember(MemberStatus s, List<Circle> circles) {
  for (final c in circles) {
    for (final m in c.members) {
      final match = (m.uid != null && m.uid == s.uid) ||
          (m.uid == null && m.name.trim().toLowerCase() == s.name.trim().toLowerCase());
      if (match && m.digits.isNotEmpty) return m.fullPhone;
    }
  }
  return null;
}

bool shouldFollow({
  required MemberStatus member,
  required LatLng? centeredAt,
  required DateTime? lastFollow,
  required DateTime now,
}) {
  if (!member.hasPosition || centeredAt == null) return false;
  if (lastFollow != null && now.difference(lastFollow) <= const Duration(seconds: 4)) {
    return false;
  }
  final meters =
      const Distance().as(LengthUnit.Meter, centeredAt, LatLng(member.lat!, member.lng!));
  return meters > (member.moving ? 60 : 150);
}

String freshnessLabel(MemberStatus s, DateTime now) {
  if (s.updatedAt == null) return appL10n.waitingFirstUpdate;
  final diff = now.difference(s.updatedAt!);
  if (diff.inMinutes < 1) return appL10n.liveUpdatedJustNow;
  if (diff > kStaleAfter) return appL10n.lastSeenAt(scClock(s.updatedAt!));
  return appL10n.updatedMinAgo(diff.inMinutes);
}

String motionLabel(MemberStatus s, {required bool stale}) {
  if (stale) return appL10n.noRecentUpdate;
  if (s.moving) return scMph(s.speedKmh) < 1 ? appL10n.moving : appL10n.movingAt(scSpeed(s.speedKmh));
  return s.since == null ? appL10n.stopped : appL10n.atPlaceSince(scClock(s.since!));
}

enum SafetyLevel { alert, late, due, calm }

class SafetyStrip {
  const SafetyStrip._(this.level, this.label, {this.alert});

  final SafetyLevel level;
  final String label;

  final SafetyAlert? alert;

  static SafetyStrip? of(List<SafetyAlert> alerts, List<Journey> journeys, DateTime now) {
    if (alerts.isNotEmpty) {
      return SafetyStrip._(SafetyLevel.alert, alerts.first.headline, alert: alerts.first);
    }
    if (journeys.isEmpty) return null;
    final late = journeys.where((j) => j.isOverdue(now)).length;
    if (late > 0) {
      return SafetyStrip._(
          SafetyLevel.late, appL10n.friendsNeedAttention(late));
    }
    final due = journeys.where((j) => j.nextCheckIn?.isDueNow(now) ?? false).toList();
    if (due.length == 1) {
      return SafetyStrip._(SafetyLevel.due, appL10n.namesCheckInDue(due.first.ownerFirstName));
    }
    if (due.length > 1) return SafetyStrip._(SafetyLevel.due, appL10n.checkInsAreDue(due.length));
    final n = journeys.length;
    return SafetyStrip._(SafetyLevel.calm, appL10n.friendsOnJourney(n));
  }
}
