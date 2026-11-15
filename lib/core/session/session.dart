import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionProvider = Provider<Session>((ref) => Session.instance);

final sessionChangesProvider = Provider.autoDispose<Session>((ref) {
  final session = ref.watch(sessionProvider);
  session.addListener(ref.notifyListeners);
  ref.onDispose(() => session.removeListener(ref.notifyListeners));
  return session;
});

class Session extends ChangeNotifier {
  Session();
  static final Session instance = Session();

  String uid = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String? userPhoto;

  bool mapHome = true;

  String safetyPin = '';
  String panicPin = '';

  bool matchesSafety(String pin) => safetyPin.isNotEmpty && _hash(pin) == safetyPin;
  bool matchesPanic(String pin) => panicPin.isNotEmpty && _hash(pin) == panicPin;

  String _hash(String pin) => sha256.convert(utf8.encode('$uid:$pin')).toString();

  void setProfile({
    required String uid,
    required String name,
    required String email,
    String phone = '',
    String? photo,
  }) {
    this.uid = uid;
    userName = name;
    userEmail = email;
    userPhone = phone;
    userPhoto = photo;
    notifyListeners();
  }

  void setPins({required String safety, required String panic}) {
    safetyPin = safety;
    panicPin = panic;
    notifyListeners();
  }

  void clear() {
    uid = '';
    userName = '';
    userEmail = '';
    userPhone = '';
    userPhoto = null;
    safetyPin = '';
    panicPin = '';
    notifyListeners();
  }
}
