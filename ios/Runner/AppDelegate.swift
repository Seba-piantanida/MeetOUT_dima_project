import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices. provideAPIKey ("AIzaSyCMtEMbBqDdj3td0jpQb2x0nx4hBona7-s")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
