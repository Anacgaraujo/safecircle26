import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/l10n/l10n.dart';

void main() {
  test('the app speaks English, Portuguese, Spanish, French, Mandarin and Hindi', () {
    expect(AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
        {'en', 'pt', 'es', 'fr', 'zh', 'hi'});
  });

  test('every language fills in names and counts', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      expect(l.alertHeadlineHelp('Ana'), contains('Ana'), reason: '$locale');
      expect(l.participantCount(1), isNotEmpty, reason: '$locale');
      expect(l.participantCount(3), contains('3'), reason: '$locale');
      expect(l.circlesSummary(2, 5), allOf(contains('2'), contains('5')), reason: '$locale');
      expect(l.resendTooSoon('Bia', 4), allOf(contains('Bia'), contains('4')), reason: '$locale');
    }
  });

  test('a few translations read as expected', () {
    expect(lookupAppLocalizations(const Locale('pt')).tabEmergency, 'Emergência');
    expect(lookupAppLocalizations(const Locale('es')).participantCount(2), '2 participantes');
    expect(lookupAppLocalizations(const Locale('fr')).cancel, 'Annuler');
    expect(lookupAppLocalizations(const Locale('zh')).tabCircles, '圈子');
    expect(lookupAppLocalizations(const Locale('hi')).tabCircles, 'सर्कल');
  });
}
