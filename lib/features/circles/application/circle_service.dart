import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';

final circleServiceProvider =
    Provider<CircleService>((ref) => CircleService(ref.watch(circleRepositoryProvider)));

class CircleService {
  CircleService(this._circles);

  final CircleRepository _circles;

  Future<List<String>> saveAndInvite(Circle circle, {required bool isNew}) async {
    if (isNew) {
      await _circles.createCircle(circle);
    } else {
      await _circles.updateCircle(circle);
    }
    final missing = <String>[];
    for (final m in circle.members) {
      final email = m.email ?? '';
      if (email.isEmpty) continue;
      if (!await _circles.sendInvite(circle: circle, toEmail: email)) missing.add(email);
    }
    return missing;
  }

  Future<void> removeMember(Circle circle, Person member) async {
    circle.members.remove(member);
    await _circles.removeMember(circle, member);
  }
}
