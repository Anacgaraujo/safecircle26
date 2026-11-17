import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/l10n/l10n.dart';

String circlesSummary(List<Circle> circles) {
  final m = circles.fold<int>(0, (n, c) => n + c.members.length);
  return appL10n.circlesSummary(circles.length, m);
}

enum PinKind { safety, panic }

String? pinChangeError(Session session, PinKind kind, String current, String next) {
  final isSafety = kind == PinKind.safety;
  final currentOk = isSafety ? session.matchesSafety(current) : session.matchesPanic(current);
  if (!currentOk) return isSafety ? appL10n.currentPinWrong : appL10n.currentPanicPinWrong;
  if (next.length != 4) return appL10n.newPinFourDigits;
  final clashes = isSafety ? session.matchesPanic(next) : session.matchesSafety(next);
  if (clashes) return isSafety ? appL10n.mustDifferFromPanic : appL10n.mustDifferFromSafety;
  return null;
}

String? emailChangeError(String newEmail, String password) {
  final email = newEmail.trim();
  if (!email.contains('@') || !email.contains('.')) return appL10n.enterValidEmail;
  if (password.isEmpty) return appL10n.enterCurrentPassword;
  return null;
}

String? passwordChangeError(String next, String repeat) {
  if (next.length < 6) return appL10n.newPasswordTooShort;
  if (next != repeat) return appL10n.passwordsDontMatch;
  return null;
}
