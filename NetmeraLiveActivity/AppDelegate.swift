import UIKit
import NetmeraNotification
import NetmeraLiveActivity
import ActivityKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        Netmera.initialize()
        // Use .debug mode to view detailed Netmera logs
        Netmera.setLogLevel(.debug) // Options: .debug, .info, .error, .fault
        // Set the delegate for the notification center and request authorization
        UNUserNotificationCenter.current().delegate = self
        Netmera.requestPushNotificationAuthorization(for: [.alert, .badge, .sound])

        /*
         Starting from iOS 17.2, Live Activities must be registered with Netmera
         to enable push-based tracking of specific activity types.
         The `register(forType:name:)` method listens for token updates related to a particular activity type.
         This call can be placed inside AppDelegate's `application(_:didFinishLaunchingWithOptions:)`
         or anywhere appropriate in the app's lifecycle.
         In this case, the registration is triggered via the custom `LiveActivityManager` class.
        */
        if #available(iOS 17.2, *) {
          LiveActivityManager.shared.registerForMatchScoreActivity()
        }

        /*
         When the app is killed, Live Activity observation stops.
         To resume observing after relaunch, call this in AppDelegate’s application(_:didFinishLaunchingWithOptions:).
         This ensures both local and remote Live Activities can be tracked again.
        */
        if #available(iOS 16.1, *) {
          Netmera.resumeObservingActivities(ofType: Activity<MatchScoreAttributes>.self)
        }
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
      _ application: UIApplication,
      configurationForConnecting connectingSceneSession: UISceneSession,
      options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      // Display the notification
        if #available(iOS 14.0, *) {
            // Use .banner and .list for iOS 14 and later
            completionHandler([.banner, .list, .badge, .sound])
        } else {
            // Use .alert for earlier versions of iOS
            completionHandler([.alert, .badge, .sound])
        }
    }

    // Handle user interaction with notifications
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      completionHandler()
    }
}
