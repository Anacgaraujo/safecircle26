import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/circles/domain/circle.dart';

String circlesSummary(List<Circle> circles) {
  final m = circles.fold<int>(0, (n, c) => n + c.members.length);
  return '${circles.length} ${circles.length == 1 ? 'circle' : 'circles'} · '
      '$m ${m == 1 ? 'member' : 'members'}';
}

enum PinKind { safety, panic }

String? pinChangeError(Session session, PinKind kind, String current, String next) {
  final isSafety = kind == PinKind.safety;
  final currentOk = isSafety ? session.matchesSafety(current) : session.matchesPanic(current);
  if (!currentOk) return isSafety ? 'Current PIN is incorrect.' : 'Current panic PIN is incorrect.';
  if (next.length != 4) return 'The new PIN must have 4 digits.';
  final clashes = isSafety ? session.matchesPanic(next) : session.matchesSafety(next);
  if (clashes) return isSafety ? 'It must differ from your panic PIN.' : 'It must differ from your safety PIN.';
  return null;
}

String? emailChangeError(String newEmail, String password) {
  final email = newEmail.trim();
  if (!email.contains('@') || !email.contains('.')) return 'Enter a valid email.';
  if (password.isEmpty) return 'Enter your current password.';
  return null;
}

String? passwordChangeError(String next, String repeat) {
  if (next.length < 6) return 'New password must have at least 6 characters.';
  if (next != repeat) return "Passwords don't match.";
  return null;
}
