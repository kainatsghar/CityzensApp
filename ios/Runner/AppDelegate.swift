import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {  // Remove UNUserNotificationCenterDelegate here

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()

        // Set Firebase Messaging delegate to handle token refresh
        Messaging.messaging().delegate = self

        // Request notification authorization and set the delegate
        UNUserNotificationCenter.current().delegate = self  // Set the delegate here
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            print("Notification permission granted: \(granted)")
        }

        // Register for remote notifications
        application.registerForRemoteNotifications()

        // Other Flutter configurations
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle APNS token registration for Firebase Messaging
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Set the APNS token for Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle Firebase token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        // Optionally send the token to your server for push notifications
    }

    // Handle notification received in the foreground (iOS 10+)
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show the notification alert, badge, and sound when the app is in the foreground
        completionHandler([.alert, .badge, .sound])
    }

    // Handle response to notification when app is in the background or terminated (iOS 10+)
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle the notification response, such as navigating to a specific screen
        completionHandler()
    }
}
