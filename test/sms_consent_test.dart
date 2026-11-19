import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/core/widgets/person_form.dart';
import 'package:safecircle/features/circles/domain/circle.dart';

void main() {
  test('texting consent is saved and defaults to no', () {
    final p = Person(name: 'Bia', countryCode: 'US', digits: '4155552671', smsConsent: true);
    expect(Person.fromMap(p.toMap()).smsConsent, isTrue);
    expect(Person.fromMap({'name': 'Old record', 'digits': '4155552671'}).smsConsent, isFalse);
  });

  Future<List<Person>> pumpForm(WidgetTester tester, Person initial, GlobalKey<PersonFormState> key) async {
    final changes = <Person>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: PersonForm(key: key, initial: initial, onChanged: changes.add),
        ),
      ),
    ));
    return changes;
  }

  testWidgets('the consent box starts unticked and ticking it is reported', (tester) async {
    final key = GlobalKey<PersonFormState>();
    final changes =
        await pumpForm(tester, Person(name: 'Bia', countryCode: 'US', digits: '4155552671'), key);
    final box = find.byKey(const ValueKey('sms-consent'));
    expect(box, findsOneWidget);
    expect(key.currentState!.buildPerson().smsConsent, isFalse);

    await tester.tap(box);
    await tester.pump();
    expect(changes.last.smsConsent, isTrue);
  });

  testWidgets('no consent box without a phone number', (tester) async {
    await pumpForm(tester, Person(name: 'Bia'), GlobalKey<PersonFormState>());
    expect(find.byKey(const ValueKey('sms-consent')), findsNothing);
  });

  testWidgets('editing loads the person, keeping their consent and ids', (tester) async {
    final key = GlobalKey<PersonFormState>();
    await pumpForm(tester, Person(name: ''), key);
    key.currentState!.load(Person(
        id: 'm1', uid: 'u1', name: 'Bia', countryCode: 'US', digits: '4155552671', smsConsent: true));
    await tester.pump();
    final p = key.currentState!.buildPerson();
    expect((p.name, p.id, p.uid, p.digits, p.smsConsent), ('Bia', 'm1', 'u1', '4155552671', true));
  });
}
