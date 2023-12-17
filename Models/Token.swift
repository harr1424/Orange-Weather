import SwiftUI

import Foundation

class TokenManager {
    static let shared = TokenManager()

    private(set) var deviceToken: String?

    func setDeviceToken(_ token: String) {
        self.deviceToken = token
    }
}
