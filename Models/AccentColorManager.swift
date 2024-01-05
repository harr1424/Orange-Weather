import SwiftUI

class AccentColorManager: ObservableObject {
    
    let colors: [Color] = [.orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .brown, .gray]

    @Published var accentColor: Color = .orange 

    @Published var accentColorIndex: Int = 0 {
        didSet {
            accentColor = colors[accentColorIndex]
            saveAccentColorIndex()
            objectWillChange.send()
        }
    }
    
    var currentAccentColor: Color {
        return colors[accentColorIndex]
    }

    init() {
        loadAccentColorIndex()
    }
    
    private let accentColorIndexKey = "AccentColorIndex"
    
    private func saveAccentColorIndex() {
        UserDefaults.standard.set(accentColorIndex, forKey: accentColorIndexKey)
    }

    private func loadAccentColorIndex() {
        if let storedIndex = UserDefaults.standard.value(forKey: accentColorIndexKey) as? Int {
            accentColorIndex = storedIndex
        }
    }
}
