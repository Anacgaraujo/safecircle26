import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<void> clearPersistedWebAuth() async {
  final done = Completer<void>();
  void finish([web.Event? _]) {
    if (!done.isCompleted) done.complete();
  }

  try {
    final req = web.window.indexedDB.deleteDatabase('firebaseLocalStorageDb');
    req.onsuccess = finish.toJS;
    req.onerror = finish.toJS;
    req.onblocked = finish.toJS;
  } catch (_) {
    finish();
  }
  await done.future.timeout(const Duration(seconds: 2), onTimeout: () {});
}
