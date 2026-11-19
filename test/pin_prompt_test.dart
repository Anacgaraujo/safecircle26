import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/widgets/pin_prompt.dart';
import 'package:safecircle/features/journeys/domain/pin_check.dart';

String _hash(String pin) => sha256.convert(utf8.encode('ana:$pin')).toString();

void main() {
  setUp(() {
    Session.instance
      ..setProfile(uid: 'ana', name: 'Ana', email: 'ana@example.com')
      ..setPins(safety: _hash('1234'), panic: _hash('9999'));
  });

  Future<PinResult?> type(WidgetTester tester, List<String> pins) async {
    PinResult? result;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => result = await askForPin(context, title: 'Pause?', body: 'Enter your PIN.'),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    for (final pin in pins) {
      for (final d in pin.split('')) {
        await tester.tap(find.text(d).last);
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }
    return result;
  }

  testWidgets('the safety PIN and the panic PIN are told apart', (tester) async {
    expect(await type(tester, ['1234']), PinResult.safety);
    expect(await type(tester, ['9999']), PinResult.panic);
  });

  testWidgets('a wrong PIN shows an error and lets you try again', (tester) async {
    final result = await type(tester, ['0000']);
    expect(result, isNull);
    expect(find.text('Incorrect PIN. Try again.'), findsOneWidget);
  });
}
