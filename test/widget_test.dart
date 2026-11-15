import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/core/widgets/sc_widgets.dart';

void main() {
  testWidgets('ScButton renders label and reacts to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScButton(label: 'Start', onPressed: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Start'), findsOneWidget);
    await tester.tap(find.text('Start'));
    expect(tapped, isTrue);
  });

  testWidgets('PinBoxes shows filled dots', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: PinBoxes(length: 2))),
    );
    expect(find.byType(PinBoxes), findsOneWidget);
  });
}
