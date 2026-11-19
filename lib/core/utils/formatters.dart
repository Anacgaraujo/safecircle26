import 'package:intl/intl.dart';

import 'package:safecircle/l10n/l10n.dart';

const kKmPerMile = 1.609344;
const _feetPerMeter = 3.28084;

/// Formats [d] in the phone's language with a pattern such as DateFormat.jm.
/// Falls back to US English if that language's date data isn't loaded
/// (main() loads it all with initializeDateFormatting; tests don't).
String scFormat(DateFormat Function(String locale) pattern, DateTime d) {
  try {
    return pattern(appLocale.toLanguageTag()).format(d);
  } catch (_) {
    return pattern('en_US').format(d);
  }
}

/// A time of day in the phone's language: "11:05 AM", "11:05", "上午11:05"…
String scClock(DateTime d) => scFormat(DateFormat.jm, d).replaceAll('\u202f', ' ');

/// "11:05 AM" in English, whatever the phone's language. For labels saved in
/// the database and used in text messages; screens show [scClock] instead.
String scClockEn(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$h:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
}

int scMph(double kmh) => (kmh / kKmPerMile).round();

String scSpeed(double kmh) => '${scMph(kmh)} mph';

String scMiles(double km) => (km / kKmPerMile).toStringAsFixed(1);

String scDistance(double km) {
  final mi = km / kKmPerMile;
  if (mi < .1) return '${(km * 1000 * _feetPerMeter / 10).round() * 10} ft';
  return '${mi.toStringAsFixed(1)} mi';
}

String scFeet(double meters) => '${(meters * _feetPerMeter / 10).round() * 10} ft';

const _monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// "Nov 16, 2026" in English, saved with each journey; screens show [scDate].
String scDateLabel(DateTime d) => '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';

/// "Today", "Tomorrow" or a short date, in the phone's language.
String scDayLabel(DateTime at, DateTime now) {
  final days = DateTime(at.year, at.month, at.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
  if (days == 0) return appL10n.today;
  if (days == 1) return appL10n.tomorrow;
  return scFormat(DateFormat.Md, at);
}

/// A date in the phone's language: "Nov 16, 2026", "16 de nov. de 2026"…
String scDate(DateTime d) => scFormat(DateFormat.yMMMd, d);
