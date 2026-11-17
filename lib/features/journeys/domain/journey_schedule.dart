import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/features/journeys/domain/journey.dart';
import 'package:safecircle/l10n/l10n.dart';

DateTime roundUpToHalfHour(DateTime t) {
  final add = (30 - t.minute % 30) % 30;
  return DateTime(t.year, t.month, t.day, t.hour, t.minute)
      .add(Duration(minutes: add == 0 ? 30 : add));
}

/// English day label saved with the check-in; screens show
/// [CheckIn.dateText] in the phone's language instead.
String dayLabel(DateTime at, DateTime now) {
  final days = DateTime(at.year, at.month, at.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
  if (days == 0) return 'Today';
  if (days == 1) return 'Tomorrow';
  return '${at.month}/${at.day}';
}

CheckIn checkInAt(String label, DateTime at, {required DateTime now}) => CheckIn(
    label: label, date: dayLabel(at, now), time: scClockEn(at), atMillis: at.millisecondsSinceEpoch);

void reschedule(CheckIn checkIn, DateTime at, {required DateTime now}) {
  checkIn
    ..date = dayLabel(at, now)
    ..time = scClockEn(at)
    ..atMillis = at.millisecondsSinceEpoch;
}

List<CheckIn> defaultCheckIns(DateTime now) {
  final base = roundUpToHalfHour(now);
  return [
    checkInAt(appL10n.firstCheckIn, base.add(const Duration(hours: 1)), now: now),
    checkInAt(appL10n.secondCheckIn, base.add(const Duration(hours: 2, minutes: 30)), now: now),
    checkInAt(appL10n.checkOut, base.add(const Duration(hours: 4)), now: now),
  ];
}

void addCheckIn(List<CheckIn> checkIns, DateTime now) {
  checkIns.insert(
      checkIns.length - 1,
      checkInAt(appL10n.numberedCheckIn(checkIns.length),
          roundUpToHalfHour(now).add(const Duration(hours: 3)),
          now: now));
}

DateTime? nextOccurrence(int hour, int minute, DateTime now) {
  var at = DateTime(now.year, now.month, now.day, hour, minute);
  if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
  if (!at.isAfter(now.add(const Duration(minutes: 1)))) return null;
  return at;
}

CheckIn? firstPastCheckIn(List<CheckIn> checkIns, DateTime now) {
  for (final c in checkIns) {
    if (c.at != null && !c.at!.isAfter(now)) return c;
  }
  return null;
}

void sortChronologically(List<CheckIn> checkIns) =>
    checkIns.sort((a, b) => (a.atMillis ?? 0).compareTo(b.atMillis ?? 0));

String journeyDuration(DateTime? startedAt, DateTime now) {
  final mins = startedAt == null ? 0 : now.difference(startedAt).inMinutes;
  return '${mins ~/ 60}h ${(mins % 60).toString().padLeft(2, '0')}m';
}

List<(CheckIn, CheckInState)> checkInTimeline(List<CheckIn> checkIns, DateTime now) {
  final out = <(CheckIn, CheckInState)>[];
  var nextAssigned = false;
  for (final c in checkIns) {
    if (c.confirmed) {
      out.add((c, CheckInState.done));
    } else if (!nextAssigned) {
      out.add((c, c.isLate(now) ? CheckInState.missed : CheckInState.next));
      nextAssigned = true;
    } else {
      out.add((c, CheckInState.future));
    }
  }
  return out;
}
