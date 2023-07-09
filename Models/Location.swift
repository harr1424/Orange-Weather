import Foundation
import SwiftUI

struct Location: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
}
