import Flutter
import UIKit
import UserNotifications

// SafeCircle keeps the classic (non-scene) app lifecycle on purpose:
// flutter_contacts reads the app delegate's window when it registers and
// crashes on launch under the UIScene lifecycle. Don't migrate this file
// until every plugin supports UIScene.
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Taps on the app's own (local) notifications reach Flutter through this.
    UNUserNotificationCenter.current().delegate = self
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
