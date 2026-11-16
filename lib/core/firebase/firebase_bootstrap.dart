import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:safecircle/firebase_options.dart';
import 'package:safecircle/core/firebase/web_auth_reset.dart' if (dart.library.js_interop) 'package:safecircle/core/firebase/web_auth_reset_web.dart';

const kUseEmulators = bool.fromEnvironment('USE_EMULATORS');
const kEmulatorHost = String.fromEnvironment('EMULATOR_HOST', defaultValue: 'localhost');

const _emulatorOnlyApiKey = 'emulator-only-invalid-key';

FirebaseOptions firebaseOptions() {
  final o = DefaultFirebaseOptions.currentPlatform;
  if (!kUseEmulators || !kIsWeb) return o;
  return FirebaseOptions(
    apiKey: _emulatorOnlyApiKey,
    appId: o.appId,
    messagingSenderId: o.messagingSenderId,
    projectId: o.projectId,
    authDomain: o.authDomain,
    storageBucket: o.storageBucket,
  );
}

Future<void> initFirebase() async {
  if (kUseEmulators && kIsWeb) await clearPersistedWebAuth();
  await Firebase.initializeApp(options: firebaseOptions());
  if (kUseEmulators) {
    await FirebaseAuth.instance.useAuthEmulator(kEmulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(kEmulatorHost, 8080);
    FirebaseFunctions.instance.useFunctionsEmulator(kEmulatorHost, 5001);
  }
}
