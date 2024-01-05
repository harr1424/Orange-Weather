import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Request permissions first
        permissionRequest { granted in
            if granted {
                // If permission is granted, register for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                // Handle the case where permission is not granted
                print("Notification permission not granted.")
            }
        }
        
        return true
    }

    func permissionRequest(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
            completion(granted)
        }
        
        // Perform UI-related tasks on the main thread
        DispatchQueue.main.async {
            let dismissAction = UNNotificationAction(identifier: "DISMISS", title: "OK", options: [])
            let frostNotification = UNNotificationCategory(identifier: "FROST", actions: [dismissAction], intentIdentifiers: [])
            center.setNotificationCategories([frostNotification])
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        TokenManager.shared.setDeviceToken(token)
        
        let url = URL(string: ApiServer + "register")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["token": token]
        
        print("Sending \(parameters) to Registration Endpoint")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Could not serialize device token: \(error.localizedDescription)")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error initiating data task: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (httpResponse.statusCode == 201)
            else {
                print("Invalid response from APNs server")
                return
            }
        }
        task.resume()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}

@main
struct Orange_WeatherApp: App {
    @StateObject private var accentColorManager = AccentColorManager()

    var body: some Scene {
        WindowGroup {
            MainWeatherView()
                .environmentObject(accentColorManager)
        }
    }
}
