import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/notifications/push_service.dart';

void main() {
  test('check-in reminders open the journey', () {
    expect(PushTarget.fromPayload('journey'), isA<JourneyTarget>());
  });

  test('alerts open that alert', () {
    final t = PushTarget.fromPayload('alert:abc123');
    expect(t, isA<AlertTarget>());
    expect((t as AlertTarget).alertId, 'abc123');
  });

  test('invites open the circles tab', () {
    expect(PushTarget.fromPayload('invite'), isA<InviteTarget>());
  });

  test('no payload opens nothing', () {
    expect(PushTarget.fromPayload(null), isNull);
    expect(PushTarget.fromPayload(''), isNull);
    expect(PushTarget.fromPayload('alert:'), isNull);
  });
}
