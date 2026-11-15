import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/features/journeys/data/journey_monitor.dart';
import 'package:safecircle/features/live_map/data/tracking_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      ref.watch(firebaseAuthProvider),
      beforeSignOut: () async {
        JourneyMonitor.instance.stop();
        await TrackingService.instance.stop(markPaused: false);
      },
    ));

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
  retry: (_, __) => null,
);

class AuthRepository {
  AuthRepository(this._auth, {Future<void> Function()? beforeSignOut})
      : _beforeSignOut = beforeSignOut;

  final FirebaseAuth _auth;
  final Future<void> Function()? _beforeSignOut;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User> register(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: _normalize(email),
      password: password,
    );
    return cred.user!;
  }

  Future<User> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: _normalize(email),
      password: password,
    );
    return cred.user!;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: _normalize(email));

  Future<void> changeEmail({
    required String currentEmail,
    required String password,
    required String newEmail,
  }) async {
    final user = await _reauthenticate(currentEmail, password);
    await user.verifyBeforeUpdateEmail(_normalize(newEmail));
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = await _reauthenticate(email, currentPassword);
    await user.updatePassword(newPassword);
  }

  Future<void> logout() async {
    await _beforeSignOut?.call();
    await _auth.signOut();
  }

  Future<void> deleteAccount() async => _auth.currentUser?.delete();

  Future<User> _reauthenticate(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'requires-recent-login');
    await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return user;
  }

  static String _normalize(String email) => email.trim().toLowerCase();
}
