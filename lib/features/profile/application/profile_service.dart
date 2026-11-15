import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/notifications/notification_service.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/features/auth/data/auth_repository.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';
import 'package:safecircle/features/profile/domain/profile_rules.dart';

final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService(
      users: ref.watch(userRepositoryProvider),
      auth: ref.watch(authRepositoryProvider),
      session: ref.watch(sessionProvider),
      applyNotificationSetting: (key, value) {
        final n = NotificationService.instance;
        switch (key) {
          case 'checkinReminder':
            n.checkinReminder = value;
          case 'circleAlerts':
            n.circleAlerts = value;
          case 'overdueAlerts':
            n.overdueAlerts = value;
        }
      },
    ));

class ProfileException implements Exception {
  ProfileException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ProfileService {
  ProfileService({
    required this.users,
    required this.auth,
    required this.session,
    this.applyNotificationSetting,
  });

  final UserRepository users;
  final AuthRepository auth;
  final Session session;
  final void Function(String key, bool value)? applyNotificationSetting;

  Future<void> updateProfile({required String name, required String phone}) async {
    final n = name.trim().isEmpty ? session.userName : name.trim();
    await users.updateUserProfile(name: n, phone: phone);
    session.setProfile(
        uid: session.uid, name: n, email: session.userEmail, phone: phone, photo: session.userPhoto);
  }

  Future<void> updatePhoto(String path) async {
    await users.updateUserProfile(photoPath: path);
    session.setProfile(
        uid: session.uid,
        name: session.userName,
        email: session.userEmail,
        phone: session.userPhone,
        photo: path);
  }

  Future<void> changePin(PinKind kind, {required String current, required String next}) async {
    final error = pinChangeError(session, kind, current, next);
    if (error != null) throw ProfileException(error);
    await (kind == PinKind.safety ? users.savePins(safety: next) : users.savePins(panic: next));
  }

  Future<void> changeEmail({required String newEmail, required String password}) async {
    final error = emailChangeError(newEmail, password);
    if (error != null) throw ProfileException(error);
    await auth.changeEmail(
        currentEmail: session.userEmail, password: password, newEmail: newEmail.trim().toLowerCase());
  }

  Future<void> changePassword(
      {required String current, required String next, required String repeat}) async {
    final error = passwordChangeError(next, repeat);
    if (error != null) throw ProfileException(error);
    await auth.changePassword(email: session.userEmail, currentPassword: current, newPassword: next);
  }

  Future<void> setNotificationSetting(String key, bool value) {
    applyNotificationSetting?.call(key, value);
    return users.saveSetting(key, value);
  }

  Future<void> deleteAccount() async {
    await users.deleteMyData();
    try {
      await auth.deleteAccount();
    } catch (_) {}
    await auth.logout();
  }
}
