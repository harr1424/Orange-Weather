import SwiftUI
import CoreLocation

struct SettingsView: View {
    @StateObject var savedLocations = SavedLocations()
    @ObservedObject var networking: Networking

    var body: some View {
        List {
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
}

