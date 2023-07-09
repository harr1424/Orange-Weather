import Foundation

class UserEngagement {
    public var points: Int = (UserDefaults.standard.object(forKey: "Points")) as? Int ?? 0
}
