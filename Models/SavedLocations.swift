import Foundation
import SwiftUI

class SavedLocations: ObservableObject {
    @AppStorage("Locations") var all: [Location] = []
        
    func deleteLocation(at offsets: IndexSet) {
        all.remove(atOffsets: offsets)
        UserDefaults.standard.set(all, forKey: "SavedLocations")
    }
}
