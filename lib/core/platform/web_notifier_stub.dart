class WebNotifier {
  static bool get supported => false;
  static bool get granted => false;
  static Future<bool> requestPermission() async => false;
  static void show(String title, String body) {}
}
