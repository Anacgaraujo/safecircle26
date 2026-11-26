import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/places/application/place_service.dart';
import 'package:safecircle/features/places/data/place_repository.dart';
import 'package:safecircle/features/places/presentation/place_sheet.dart';
import 'package:safecircle/l10n/l10n.dart';

class _SavingPlaces extends PlaceService {
  _SavingPlaces()
      : super(PlaceRepository(FakeFirebaseFirestore(), currentUid: () => 'me'),
            session: Session.instance);

  Place? saved;
  Circle? savedTo;

  @override
  Future<String> save(Place place, Circle? circle) async {
    saved = place;
    savedTo = circle;
    return 'p1';
  }
}

void main() {
  final family = Circle(id: 'fam', name: 'Family', memberIds: ['me', 'jamie']);
  final work = Circle(id: 'work', name: 'Work friends', memberIds: ['me', 'sam']);

  Future<_SavingPlaces> show(WidgetTester tester, List<Circle> circles) async {
    final places = _SavingPlaces();
    tester.view.physicalSize = const Size(1200, 4200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        myCirclesProvider.overrideWith((ref) => Stream.value(circles)),
        placeServiceProvider.overrideWithValue(places),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => PlaceSheet(
                  circle: family,
                  // An existing spot, so the sheet doesn't ask for the location.
                  existing: Place(id: 'p1', circleId: 'fam', name: 'Gym', lat: 37.79, lng: -122.39),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    // Let the sheet slide up and the circles arrive.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return places;
  }

  testWidgets('a place can be moved to another circle', (tester) async {
    final places = await show(tester, [family, work]);
    expect(find.text('CIRCLE THAT GETS THE ALERTS'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);

    await tester.ensureVisible(find.text('Work friends'));
    await tester.tap(find.text('Work friends'));
    await tester.pump();
    await tester.ensureVisible(find.text('Save Place'));
    await tester.tap(find.text('Save Place'));
    await tester.pump(const Duration(seconds: 1));

    expect(places.savedTo?.id, 'work');
    expect(places.saved?.circleId, 'work');
    await tester.pump(const Duration(seconds: 5)); // the "saved" toast
  });

  testWidgets('with one circle there is nothing to choose', (tester) async {
    final places = await show(tester, [family]);
    expect(find.text('CIRCLE THAT GETS THE ALERTS'), findsNothing);

    await tester.ensureVisible(find.text('Save Place'));
    await tester.tap(find.text('Save Place'));
    await tester.pump(const Duration(seconds: 1));
    expect(places.savedTo?.id, 'fam');
    await tester.pump(const Duration(seconds: 5)); // the "saved" toast
  });
}
