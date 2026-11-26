import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safecircle/core/utils/actions.dart';

void main() {
  test('iPhone: one person uses sms:', () {
    expect(smsUri(['+15551234567'], platform: TargetPlatform.iOS).toString(), 'sms:+15551234567');
  });

  test('iPhone: several people and a message', () {
    expect(
      smsUri(['+15551234567', '+15557654321'], body: 'I am OK', platform: TargetPlatform.iOS)
          .toString(),
      'sms://open?addresses=+15551234567,+15557654321&body=I%20am%20OK',
    );
  });

  test('Android keeps smsto:', () {
    expect(smsUri(['+15551234567'], platform: TargetPlatform.android).toString(),
        'smsto:+15551234567');
  });
}
