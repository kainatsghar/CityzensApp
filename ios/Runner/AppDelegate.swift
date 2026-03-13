import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate, FlutterImplicitEngineDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase (process-level → stays here)
        FirebaseApp.configure()

        // Set Firebase Messaging delegate (stays here)
        Messaging.messaging().delegate = self

        // Request notification authorization and set the delegate (stays here)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            print("Notification permission granted: \(granted)")
        }

        // Register for remote notifications (stays here)
        application.registerForRemoteNotifications()

        // IMPORTANT: Do NOT register plugins here anymore

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // ← NEW REQUIRED METHOD for customized AppDelegates
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        // Register all plugins (including firebase_messaging, etc.) here
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        // If you ever add custom method channels or platform views in the future,
        // create them here using engineBridge.applicationRegistrar.messenger()
    }

    // Handle APNS token registration for Firebase Messaging (stays here – no Scene equivalent)
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle Firebase token refresh (stays here)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        // Optionally send token to your server
    }

    // Handle notification received in foreground (stays in AppDelegate)
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show alert/badge/sound in foreground
        completionHandler([.alert, .badge, .sound])
    }

    // Handle tap on notification (when app background/terminated) — stays in AppDelegate
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle deep link / navigation here if needed
        completionHandler()
    }
}