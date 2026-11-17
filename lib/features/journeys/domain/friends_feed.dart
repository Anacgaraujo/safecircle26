import 'package:safecircle/features/alerts/domain/safety_alert.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/l10n/l10n.dart';

class FriendsFeed {
  FriendsFeed._({
    required this.journeys,
    required this.overdue,
    required this.onTime,
    required this.standaloneAlerts,
    required this.panicOwners,
  });

  factory FriendsFeed(List<Journey> journeys, List<SafetyAlert> alerts, DateTime now) {
    final alertUids = alerts.map((a) => a.fromUid).toSet();
    final journeyUids = journeys.map((j) => j.ownerId).toSet();
    final overdue =
        journeys.where((j) => j.isOverdue(now) || alertUids.contains(j.ownerId)).toList();
    return FriendsFeed._(
      journeys: journeys,
      overdue: overdue,
      onTime: journeys.where((j) => !overdue.contains(j)).toList(),
      standaloneAlerts: alerts.where((a) => !journeyUids.contains(a.fromUid)).toList(),
      panicOwners: alerts.where((a) => a.type == 'panic').map((a) => a.fromUid).toSet(),
    );
  }

  final List<Journey> journeys;
  final List<Journey> overdue;
  final List<Journey> onTime;
  final List<SafetyAlert> standaloneAlerts;
  final Set<String> panicOwners;

  bool get isEmpty => journeys.isEmpty && standaloneAlerts.isEmpty;

  bool isPanic(Journey j) => panicOwners.contains(j.ownerId);

  String get summary {
    final needsAttention = overdue.length + standaloneAlerts.length;
    final n = journeys.length;
    return needsAttention > 0
        ? appL10n.friendsNeedAttentionActive(needsAttention, n)
        : appL10n.friendsOnJourneyNow(n);
  }
}

List<Journey> overdueToNotify(List<Journey> watched, List<SafetyAlert> alerts, DateTime now) {
  final alertUids = alerts.map((a) => a.fromUid).toSet();
  return watched
      .where((j) => j.isOverdue(now) && !j.alertRaised && !alertUids.contains(j.ownerId))
      .toList();
}
