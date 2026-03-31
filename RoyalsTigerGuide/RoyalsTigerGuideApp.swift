import SwiftUI
import SwiftData
internal import StoreKit

@main
struct RoyalsTigerGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteItemRTG.self,
            JournalEntryRTG.self,
            TaskCompletionRTG.self,
            QuizResultRTG.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootViewMC()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(LoaderViewModel())
    }
}

final class AppDelegate: NSObject,
                         UIApplicationDelegate{

    private let appsFlyerDevKey = "AppsFlyer Dev Key" // ИЗМЕНИТЬ
    private let appleAppID      = "6760774470" // ИЗМЕНИТЬ

    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(IAPManagerVE.shared)
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        log("🚀 didFinishLaunching")
        SKPaymentQueue.default().add(IAPManagerVE.shared)
        UNUserNotificationCenter.current().delegate = self

        UserDefaults.standard.set(false, forKey: "apnsReady")
        UserDefaults.standard.removeObject(forKey: "apnsTokenHex")

        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func onConversionDataSuccess(_ data: [AnyHashable : Any]) {
        print("🎯 AppsFlyer Conversion Data: \(data)")
    }

    func onConversionDataFail(_ error: Error) {
        print("❌ AppsFlyer error: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log("❌ APNs register failed: \(error)")
        UserDefaults.standard.set(false, forKey: "apnsReady")
    }

    fileprivate func log(_ message: String) {
        print("[AppDelegate] \(message)")
    }

    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                if orientationLock == .landscape {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orient")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orient")
                }
            }
        }
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}


extension Notification.Name {
    static let fcmTokenDidUpdate = Notification.Name("fcmTokenDidUpdate")
    static let pushPermissionGranted = Notification.Name("pushPermissionGranted")
    static let pushPermissionDenied = Notification.Name("pushPermissionDenied")
    static let apnsTokenDidUpdate = Notification.Name("apnsTokenDidUpdate")
}

