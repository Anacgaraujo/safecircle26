class Country {
  const Country(this.code, this.dial, this.flag, this.name);
  final String code;
  final String dial;
  final String flag;
  final String name;
}

const kDefaultCountry = 'US';

const kCountries = [
  Country('US', '+1', '🇺🇸', 'United States'),
  Country('BR', '+55', '🇧🇷', 'Brazil'),
  Country('PT', '+351', '🇵🇹', 'Portugal'),
  Country('GB', '+44', '🇬🇧', 'United Kingdom'),
  Country('ES', '+34', '🇪🇸', 'Spain'),
  Country('AR', '+54', '🇦🇷', 'Argentina'),
];

Country countryByCode(String code) =>
    kCountries.firstWhere((c) => c.code == code, orElse: () => kCountries.first);

String _dialDigits(String country) => countryByCode(country).dial.substring(1);

int _nationalMax(String country) => switch (_dialDigits(country)) {
      '1' => 10,
      '55' => 11,
      _ => 12,
    };

String maskPhone(String digits, {String country = kDefaultCountry}) {
  var t = digits.replaceAll(RegExp(r'\D'), '');
  final max = _nationalMax(country);
  if (t.length > max) t = t.substring(0, max);
  switch (_dialDigits(country)) {
    case '1':
      if (t.length <= 3) return t;
      if (t.length <= 6) return '(${t.substring(0, 3)}) ${t.substring(3)}';
      return '(${t.substring(0, 3)}) ${t.substring(3, 6)}-${t.substring(6)}';
    case '55':
      if (t.length <= 2) return t;
      final area = t.substring(0, 2);
      final rest = t.substring(2);
      if (rest.length <= 4) return '$area $rest';
      return '$area ${rest.substring(0, rest.length - 4)}-${rest.substring(rest.length - 4)}';
    default:
      return t;
  }
}

String nationalDigits(String raw, {String country = kDefaultCountry}) {
  var d = raw.replaceAll(RegExp(r'\D'), '');
  final dial = _dialDigits(country);
  if (d.startsWith('00')) d = d.substring(2);
  if (d.length > _nationalMax(country) && d.startsWith(dial)) d = d.substring(dial.length);
  return d.replaceFirst(RegExp(r'^0+'), '');
}

String formatPhone(String country, String digits) =>
    '${countryByCode(country).dial} ${maskPhone(digits, country: country)}';

(String country, String digits) parsePhone(String raw) {
  final m = RegExp(r'^\(?\+(\d{1,3})\)?\s+(.*)$').firstMatch(raw.trim());
  if (m == null) return (kDefaultCountry, nationalDigits(raw));
  final code = kCountries
      .firstWhere((c) => c.dial == '+${m.group(1)}', orElse: () => countryByCode(kDefaultCountry))
      .code;
  return (code, nationalDigits(m.group(2)!, country: code));
}

String phoneE164(String country, String digits) =>
    '+${_dialDigits(country)}${nationalDigits(digits, country: country)}';

String phoneE164FromDisplay(String raw) {
  final (country, digits) = parsePhone(raw);
  return phoneE164(country, digits);
}
