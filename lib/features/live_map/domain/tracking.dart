import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/l10n/l10n.dart';

const kStaleAfter = Duration(minutes: 15);

const kSpeedLimitKmh = 80 * kKmPerMile;

const kTripStartRadiusM = 200.0;

const kTripStopAfter = Duration(minutes: 5);

class MemberStatus {
  MemberStatus({
    required this.uid,
    required this.name,
    this.photo,
    this.lat,
    this.lng,
    this.place = '',
    this.moving = false,
    this.speedKmh = 0,
    this.battery = -1,
    this.charging = false,
    this.sharing = true,
    this.since,
    this.updatedAt,
    this.tripsToday = 0,
    this.metersToday = 0,
  });

  final String uid;
  final String name;
  final String? photo;
  final double? lat;
  final double? lng;

  final String place;
  final bool moving;
  final double speedKmh;

  final int battery;
  final bool charging;

  final bool sharing;

  final DateTime? since;
  final DateTime? updatedAt;
  final int tripsToday;
  final double metersToday;

  String get firstName => name.trim().split(' ').first;
  bool get hasPosition => lat != null && lng != null;
  bool get lowBattery => battery >= 0 && battery <= 20 && !charging;

  bool isStale(DateTime now) =>
      updatedAt == null || now.difference(updatedAt!) > kStaleAfter;

  String get todayLabel {
    final km = metersToday / 1000;
    return km / kKmPerMile < .1
        ? appL10n.tripsToday(tripsToday)
        : appL10n.tripsTodayMiles(tripsToday, scMiles(km));
  }

  factory MemberStatus.fromMap(Map<String, dynamic> m, String id) => MemberStatus(
        uid: id,
        name: (m['name'] ?? '') as String,
        photo: m['photo'] as String?,
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        place: (m['place'] ?? '') as String,
        moving: (m['moving'] ?? false) as bool,
        speedKmh: ((m['speedKmh'] ?? 0) as num).toDouble(),
        battery: ((m['battery'] ?? -1) as num).toInt(),
        charging: (m['charging'] ?? false) as bool,
        sharing: (m['sharing'] ?? true) as bool,
        since: _millisToDate(m['sinceMillis']),
        updatedAt: _millisToDate(m['updatedMillis']),
        tripsToday: ((m['tripsToday'] ?? 0) as num).toInt(),
        metersToday: ((m['metersToday'] ?? 0) as num).toDouble(),
      );
}

DateTime? _millisToDate(Object? millis) =>
    millis == null ? null : DateTime.fromMillisecondsSinceEpoch((millis as num).toInt());

class Place {
  Place({
    this.id,
    required this.circleId,
    required this.name,
    this.icon = 'mapPin',
    required this.lat,
    required this.lng,
    this.radiusM = 250,
    this.notifyArrive = true,
    this.notifyLeave = true,
    this.enabled = true,
    this.address = '',
    List<String>? memberIds,
    List<String>? viewerIds,
  })  : memberIds = memberIds ?? [],
        viewerIds = viewerIds ?? [];

  String? id;
  String circleId;
  String name;
  String icon;
  double lat;
  double lng;
  double radiusM;
  bool notifyArrive;
  bool notifyLeave;
  bool enabled;
  String address;

  final List<String> memberIds;

  final List<String> viewerIds;

  String get ruleLabel {
    if (!enabled) return appL10n.alertsOff;
    if (notifyArrive && notifyLeave) return appL10n.alertArriveLeave;
    if (notifyArrive) return appL10n.alertArrive;
    if (notifyLeave) return appL10n.alertLeave;
    return appL10n.alertsOff;
  }

  Map<String, dynamic> toMap() => {
        'circleId': circleId,
        'name': name,
        'icon': icon,
        'lat': lat,
        'lng': lng,
        'radiusM': radiusM,
        'notifyArrive': notifyArrive,
        'notifyLeave': notifyLeave,
        'enabled': enabled,
        'address': address,
        'memberIds': memberIds,
      };

  factory Place.fromMap(Map<String, dynamic> m, String id) => Place(
        id: id,
        circleId: (m['circleId'] ?? '') as String,
        name: (m['name'] ?? '') as String,
        icon: (m['icon'] ?? 'mapPin') as String,
        lat: ((m['lat'] ?? 0) as num).toDouble(),
        lng: ((m['lng'] ?? 0) as num).toDouble(),
        radiusM: ((m['radiusM'] ?? 250) as num).toDouble(),
        notifyArrive: (m['notifyArrive'] ?? true) as bool,
        notifyLeave: (m['notifyLeave'] ?? true) as bool,
        enabled: (m['enabled'] ?? true) as bool,
        address: (m['address'] ?? '') as String,
        memberIds: ((m['memberIds'] ?? const []) as List).cast<String>(),
        viewerIds: ((m['viewerIds'] ?? const []) as List).cast<String>(),
      );
}

class TripPoint {
  const TripPoint({required this.lat, required this.lng, required this.atMillis, this.speedKmh = 0});
  final double lat;
  final double lng;
  final int atMillis;
  final double speedKmh;

  DateTime get at => DateTime.fromMillisecondsSinceEpoch(atMillis);

  Map<String, dynamic> toMap() => {'lat': lat, 'lng': lng, 'at': atMillis, 'speed': speedKmh};

  factory TripPoint.fromMap(Map<String, dynamic> m) => TripPoint(
        lat: ((m['lat'] ?? 0) as num).toDouble(),
        lng: ((m['lng'] ?? 0) as num).toDouble(),
        atMillis: ((m['at'] ?? 0) as num).toInt(),
        speedKmh: ((m['speed'] ?? 0) as num).toDouble(),
      );
}

class Trip {
  Trip({
    required this.id,
    required this.userId,
    required this.userName,
    required this.points,
    required this.startMillis,
    required this.endMillis,
    this.fromLabel = '',
    this.toLabel = '',
    this.distanceM = 0,
    this.maxSpeedKmh = 0,
  });

  final String id;
  final String userId;
  final String userName;
  final List<TripPoint> points;
  final int startMillis;
  final int endMillis;
  final String fromLabel;
  final String toLabel;
  final double distanceM;
  final double maxSpeedKmh;

  DateTime get start => DateTime.fromMillisecondsSinceEpoch(startMillis);
  DateTime get end => DateTime.fromMillisecondsSinceEpoch(endMillis);
  bool get overLimit => maxSpeedKmh > kSpeedLimitKmh;
  double get km => distanceM / 1000;
  String get title =>
      '${fromLabel.isEmpty ? appL10n.tripStart : fromLabel} → ${toLabel.isEmpty ? appL10n.tripEnd : toLabel}';

  List<double> get overLimitAt {
    if (points.length < 2) return const [];
    final total = endMillis - startMillis;
    if (total <= 0) return const [];
    final out = <double>[];
    for (final p in points) {
      if (p.speedKmh > kSpeedLimitKmh) {
        final t = ((p.atMillis - startMillis) / total).clamp(0.0, 1.0);
        if (out.every((o) => (o - t).abs() > .05)) out.add(t);
      }
    }
    return out;
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'startMillis': startMillis,
        'endMillis': endMillis,
        'fromLabel': fromLabel,
        'toLabel': toLabel,
        'distanceM': distanceM,
        'maxSpeedKmh': maxSpeedKmh,
        'points': points.map((p) => p.toMap()).toList(),
      };

  factory Trip.fromMap(Map<String, dynamic> m, String id) => Trip(
        id: id,
        userId: (m['userId'] ?? '') as String,
        userName: (m['userName'] ?? '') as String,
        startMillis: ((m['startMillis'] ?? 0) as num).toInt(),
        endMillis: ((m['endMillis'] ?? 0) as num).toInt(),
        fromLabel: (m['fromLabel'] ?? '') as String,
        toLabel: (m['toLabel'] ?? '') as String,
        distanceM: ((m['distanceM'] ?? 0) as num).toDouble(),
        maxSpeedKmh: ((m['maxSpeedKmh'] ?? 0) as num).toDouble(),
        points: ((m['points'] ?? const []) as List)
            .map((e) => TripPoint.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    this.placeName = '',
    this.detail = '',
    this.atMillis = 0,
  });

  final String id;
  final String userId;
  final String userName;

  final String type;
  final String placeName;
  final String detail;
  final int atMillis;

  DateTime get at => DateTime.fromMillisecondsSinceEpoch(atMillis);
  String get firstName => userName.trim().split(' ').first;

  String get title => switch (type) {
        'arrive' => appL10n.arrivedAtPlace(firstName, placeName),
        'leave' => appL10n.leftPlaceNamed(firstName, placeName),
        _ => appL10n.hasLowBattery(firstName),
      };

  String get subtitle => type == 'lowBattery'
      ? appL10n.lowBatterySub(detail)
      : scClock(at);

  factory ActivityEvent.fromMap(Map<String, dynamic> m, String id) => ActivityEvent(
        id: id,
        userId: (m['userId'] ?? '') as String,
        userName: (m['userName'] ?? '') as String,
        type: (m['type'] ?? 'arrive') as String,
        placeName: (m['placeName'] ?? '') as String,
        detail: (m['detail'] ?? '') as String,
        atMillis: ((m['atMillis'] ?? 0) as num).toInt(),
      );
}
