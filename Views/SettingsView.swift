import SwiftUI

struct FrostAlertsSectionView: View {
    @ObservedObject var savedLocations: SavedLocations
    @ObservedObject var networking: Networking
    
    var body: some View {
        Section(header: Text("Frost Alerts")) {
            if savedLocations.all.count < 1 {
                Text("Once you save one or more locations you can opt-in to receive frost alerts specific to each location.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            ForEach(savedLocations.all.indices, id: \.self) { index in
                Toggle(isOn: $savedLocations.all[index].isFrostAlertEnabled) {
                    Text(savedLocations.all[index].name)
                }
                .onChange(of: savedLocations.all[index].isFrostAlertEnabled) {
                    networking.updateFrostAlert(location: savedLocations.all[index])
                }
                .font(.title3)
            }
            .onDelete { indexSet in
                savedLocations.deleteLocation(at: indexSet)
            }
            Link("Frost Alerts are made possible using data from Open Meteo", destination: URL(string: "https://open-meteo.com")!)
        }
    }
}

struct ActiveColorSectionView: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        Section(header: Text("Active Color")) {
            VStack(alignment: .leading) {
                ForEach(accentColorManager.colors, id: \.self) { color in
                    ColorButton(color: color, isSelected: accentColorManager.currentAccentColor == color)
                        .onTapGesture {
                            if let index = accentColorManager.colors.firstIndex(of: color) {
                                accentColorManager.accentColorIndex = index
                            }
                        }
                        .padding(.vertical, 5)
                }
            }
        }
        .listRowBackground(Color(UIColor.systemBackground))
    }
}

struct ColorButton: View {
    let color: Color
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(color.description)
            Spacer()
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(isSelected ? color : .clear)
                .overlay(
                    Circle()
                        .stroke(Color.primary, lineWidth: 2)
                )
        }
        .foregroundColor(color)
    }
}


struct SettingsView: View {
    @StateObject var savedLocations = SavedLocations()
    @ObservedObject var networking: Networking
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        VStack {
            Form {
                FrostAlertsSectionView(savedLocations: savedLocations, networking: networking)
                ActiveColorSectionView()
            }
            
        }
        .navigationTitle("Settings")
        .accentColor(accentColorManager.accentColor)
    }
}
