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

  String get fromFirstName => fromName.trim().split(' ').first;

  String get kindLabel => switch (type) {
        'panic' => 'Silent panic',
        'overdue' => 'Missed check-in',
        _ => 'SOS',
      };

  String get headline =>
      type == 'overdue' ? '$fromFirstName missed a check-in' : '$fromFirstName needs help';

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
      );
}
