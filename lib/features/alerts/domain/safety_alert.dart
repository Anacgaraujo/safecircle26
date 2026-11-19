import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/l10n/l10n.dart';

class SafetyAlert {
  SafetyAlert({
    required this.id,
    required this.fromUid,
    required this.fromName,
    required this.type,
    required this.resolved,
    required this.location,
    this.timeLabel = '',
    this.fromPhone,
    this.lat,
    this.lng,
    this.watcherCount = 0,
    this.createdAt,
  });

  final String id;
  final String fromUid;
  final String fromName;
  final String type;
  final bool resolved;
  final String location;
  final String timeLabel;
  final String? fromPhone;
  final double? lat;
  final double? lng;

  final int watcherCount;

  final DateTime? createdAt;

  /// When it was raised, in the phone's language ([timeLabel] is saved in
  /// English for text messages).
  String get timeText => createdAt == null ? timeLabel : scClock(createdAt!);

  String get fromFirstName => fromName.trim().split(' ').first;

  String get kindLabel => switch (type) {
        'panic' => appL10n.alertKindPanic,
        'overdue' => appL10n.alertKindOverdue,
        _ => appL10n.alertKindSos,
      };

  String get headline => type == 'overdue'
      ? appL10n.alertHeadlineOverdue(fromFirstName)
      : appL10n.alertHeadlineHelp(fromFirstName);

  factory SafetyAlert.fromMap(Map<String, dynamic> m, String id) => SafetyAlert(
        id: id,
        fromUid: (m['fromUid'] ?? '') as String,
        fromName: (m['fromName'] ?? '') as String,
        type: (m['type'] ?? 'sos') as String,
        resolved: (m['resolved'] ?? false) as bool,
        location: (m['location'] ?? '') as String,
        timeLabel: (m['timeLabel'] ?? '') as String,
        fromPhone: m['fromPhone'] as String?,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        watcherCount: ((m['watcherIds'] ?? const []) as List).length,
        createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
      );
}
