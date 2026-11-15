const kKmPerMile = 1.609344;
const _feetPerMeter = 3.28084;

String scClock(DateTime d) {
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

String scDateLabel(DateTime d) => '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';
