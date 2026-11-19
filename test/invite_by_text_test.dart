import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/presentation/invite_by_text.dart';
import 'package:safecircle/l10n/l10n.dart';

void main() {
  group('inviteSmsUri', () {
    final ana = Person(name: 'Ana Gomes', countryCode: 'US', digits: '6562260606');

    test('opens Messages to the full number with the invitation written', () {
      final uri = inviteSmsUri(ana, 'Join me & get the app', ios: true)!;
      expect(uri.toString(), 'sms:+16562260606&body=Join%20me%20%26%20get%20the%20app');
    });

    test('Android puts the text after a question mark', () {
      final uri = inviteSmsUri(ana, 'Hi', ios: false)!;
      expect(uri.toString(), 'sms:+16562260606?body=Hi');
    });

    test('no number, no text message', () {
      expect(inviteSmsUri(Person(name: 'Zed'), 'Hi', ios: true), isNull);
    });
  });

  testWidgets('the dialog says who is not on SafeCircle and can be dismissed', (tester) async {
    final circle = Circle(name: 'Household');
    final ana = Person(name: 'Ana Gomes', email: 'ana@example.com', digits: '6562260606');
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => offerInviteByText(context, circle, ana),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text("Ana isn't on SafeCircle yet"), findsOneWidget);
    expect(find.textContaining('A text message will open'), findsOneWidget);
    expect(find.text('Send invitation'), findsOneWidget);

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.text("Ana isn't on SafeCircle yet"), findsNothing);
  });
}
