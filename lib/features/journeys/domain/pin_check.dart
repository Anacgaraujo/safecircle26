import 'package:safecircle/core/session/session.dart';

enum PinResult { safety, panic, wrong }

PinResult checkPin(Session session, String pin) {
  if (session.matchesSafety(pin)) return PinResult.safety;
  if (session.matchesPanic(pin)) return PinResult.panic;
  return PinResult.wrong;
}
