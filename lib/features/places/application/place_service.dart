import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/places/data/place_repository.dart';

final placeServiceProvider = Provider<PlaceService>((ref) => PlaceService(
      ref.watch(placeRepositoryProvider),
      session: ref.watch(sessionProvider),
    ));

List<String> placeViewers(Circle? circle, Place place, String me) {
  if (circle == null) return {...place.viewerIds, me}.toList();
  return {...circle.memberIds, me}.toList();
}

class PlaceService {
  PlaceService(this._places, {required this.session});

  final PlaceRepository _places;
  final Session session;

  Future<String> save(Place place, Circle? circle) =>
      _places.savePlace(place, viewerIds: placeViewers(circle, place, session.uid));

  Future<void> setEnabled(Place place, Circle? circle, bool enabled) {
    place.enabled = enabled;
    return save(place, circle);
  }

  Future<void> delete(String id) => _places.deletePlace(id);
}
