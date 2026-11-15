import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

class WebNotifier {
  static bool get supported => web.window.hasProperty('Notification'.toJS).toDart;

  static bool get granted => supported && web.Notification.permission == 'granted';

  static Future<bool> requestPermission() async {
    if (!supported) return false;
    try {
      final result = await web.Notification.requestPermission().toDart;
      return result.toDart == 'granted';
    } catch (_) {
      return false;
    }
  }

  static void show(String title, String body) {
    if (!granted) return;
    try {
      web.Notification(title, web.NotificationOptions(body: body, icon: 'icons/Icon-192.png'));
    } catch (_) {}
  }
}
