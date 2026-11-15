import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:safecircle/features/activity/data/activity_repository.dart';
import 'package:safecircle/features/alerts/data/alert_repository.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/contacts/data/contacts_repository.dart';
import 'package:safecircle/features/journeys/data/journey_repository.dart';
import 'package:safecircle/features/live_map/data/status_repository.dart';
import 'package:safecircle/features/places/data/place_repository.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';
import 'package:safecircle/features/trips/data/trip_repository.dart';

class Repositories {
  factory Repositories(FirebaseFirestore db) {
    final contacts = ContactsRepository(db);
    final circles = CircleRepository(db);
    final alerts = AlertRepository(db, contacts: contacts);
    return Repositories._(
      users: UserRepository(db, circles: circles),
      contacts: contacts,
      circles: circles,
      alerts: alerts,
      journeys: JourneyRepository(db, alerts: alerts),
      status: StatusRepository(db),
      places: PlaceRepository(db),
      activity: ActivityRepository(db),
      trips: TripRepository(db),
    );
  }

  Repositories._({
    required this.users,
    required this.contacts,
    required this.circles,
    required this.alerts,
    required this.journeys,
    required this.status,
    required this.places,
    required this.activity,
    required this.trips,
  });

  static Repositories? _instance;
  static Repositories get instance => _instance ??= Repositories(FirebaseFirestore.instance);

  final UserRepository users;
  final ContactsRepository contacts;
  final CircleRepository circles;
  final AlertRepository alerts;
  final JourneyRepository journeys;
  final StatusRepository status;
  final PlaceRepository places;
  final ActivityRepository activity;
  final TripRepository trips;
}
