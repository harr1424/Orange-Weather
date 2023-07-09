import Foundation
import SwiftUI

class SavedLocations: ObservableObject {
    @Published public var all: [String] = (UserDefaults.standard.object(forKey: "SavedLocations") as? [String] ?? [String]())
    
    func deleteLocation(at offsets: IndexSet) {
        all.remove(atOffsets: offsets)
        UserDefaults.standard.set(all, forKey: "SavedLocations")
    }
}
