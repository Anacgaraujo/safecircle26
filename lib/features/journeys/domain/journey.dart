import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

enum CheckInState { done, missed, next, future }

const kCheckInGrace = Duration(minutes: 5);

class CheckIn {
  CheckIn({
    required this.label,
    required this.date,
    required this.time,
    this.atMillis,
    this.confirmed = false,
    this.lat,
    this.lng,
    this.place,
  });
  String label;
  String date;
  String time;

  int? atMillis;
  bool confirmed;

  double? lat;
  double? lng;
  String? place;

  DateTime? get at => atMillis == null ? null : DateTime.fromMillisecondsSinceEpoch(atMillis!);

  bool isLate(DateTime now, {Duration grace = kCheckInGrace}) {
    if (confirmed || atMillis == null) return false;
    return now.isAfter(at!.add(grace));
  }

  bool isDueNow(DateTime now, {Duration grace = kCheckInGrace}) {
    if (confirmed || atMillis == null) return false;
    return now.isAfter(at!) && !now.isAfter(at!.add(grace));
  }

  Map<String, dynamic> toMap() => {
        'label': label,
        'date': date,
        'time': time,
        if (atMillis != null) 'atMillis': atMillis,
        'confirmed': confirmed,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (place != null) 'place': place,
      };

  factory CheckIn.fromMap(Map<String, dynamic> m) => CheckIn(
        label: (m['label'] ?? '') as String,
        date: (m['date'] ?? '') as String,
        time: (m['time'] ?? '') as String,
        atMillis: (m['atMillis'] as num?)?.toInt(),
        confirmed: (m['confirmed'] ?? false) as bool,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        place: m['place'] as String?,
      );
}

class Journey {
  Journey({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.circleId,
    required this.circleName,
    required this.status,
    required this.checkIns,
    required this.alertRaised,
    this.dateLabel = '',
    this.duration = '',
    this.ownerPhone,
    this.lastLat,
    this.lastLng,
    this.lastPlace = '',
    this.lastSeen = '',
    this.startedAt,
    this.note = '',
  });

  final String id;
  final String ownerId;
  final String ownerName;
  final String circleId;
  final String circleName;
  final String status;
  final List<CheckIn> checkIns;
  final bool alertRaised;
  final String dateLabel;
  final String duration;
  final String? ownerPhone;

  final double? lastLat;
  final double? lastLng;
  final String lastPlace;
  final String lastSeen;
  final DateTime? startedAt;
  final String note;

  String get ownerFirstName => ownerName.trim().split(' ').first;

  CheckIn? get nextCheckIn {
    for (final c in checkIns) {
      if (!c.confirmed) return c;
    }
    return null;
  }

  bool isOverdue(DateTime now) => nextCheckIn?.isLate(now) ?? false;

  CheckIn? get lastConfirmed => checkIns.where((c) => c.confirmed).lastOrNull;

  CheckIn? missedCheckIn(DateTime now) {
    final next = nextCheckIn;
    return (next != null && next.isLate(now)) ? next : null;
  }

  factory Journey.fromMap(Map<String, dynamic> m, String id) => Journey(
        id: id,
        ownerId: (m['ownerId'] ?? '') as String,
        ownerName: (m['ownerName'] ?? '') as String,
        circleId: (m['circleId'] ?? '') as String,
        circleName: (m['circleName'] ?? '') as String,
        status: (m['status'] ?? 'active') as String,
        checkIns: ((m['checkIns'] ?? []) as List)
            .map((e) => CheckIn.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        alertRaised: (m['alertRaised'] ?? false) as bool,
        dateLabel: (m['dateLabel'] ?? '') as String,
        duration: (m['duration'] ?? '') as String,
        ownerPhone: m['ownerPhone'] as String?,
        lastLat: (m['lastLat'] as num?)?.toDouble(),
        lastLng: (m['lastLng'] as num?)?.toDouble(),
        lastPlace: (m['lastPlace'] ?? '') as String,
        lastSeen: (m['lastSeen'] ?? '') as String,
        startedAt: (m['startedAt'] as Timestamp?)?.toDate(),
        note: (m['note'] ?? '') as String,
      );
}
