import 'package:flutter_test/flutter_test.dart';

import 'package:safecircle/core/notifications/push_service.dart';

void main() {
  test('reads what a tapped push should open', () {
    final alert = PushTarget.fromData({'kind': 'alert', 'alertId': 'a1'});
    expect(alert, isA<AlertTarget>());
    expect((alert as AlertTarget).alertId, 'a1');
    expect(PushTarget.fromData({'kind': 'invite'}), isA<InviteTarget>());
    expect(PushTarget.fromData({'kind': 'alert'}), isNull);
    expect(PushTarget.fromData({}), isNull);
  });
}
