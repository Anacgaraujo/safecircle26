import 'package:firebase_auth/firebase_auth.dart';
import 'package:safecircle/l10n/l10n.dart';

String describeAuthError(Object e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-email':
        return appL10n.authInvalidEmail;
      case 'email-already-in-use':
        return appL10n.authEmailInUse;
      case 'weak-password':
        return appL10n.authWeakPassword;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return appL10n.authWrongCredentials;
      case 'too-many-requests':
        return appL10n.authTooManyAttempts;
      case 'network-request-failed':
        return appL10n.authNetwork;
      case 'requires-recent-login':
        return appL10n.authReloginNeeded;
    }
    return e.message ?? appL10n.authGenericError;
  }
  return appL10n.somethingWentWrong;
}
