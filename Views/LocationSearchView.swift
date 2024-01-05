import SwiftUI
import CoreLocation

struct LocationSearchView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accentColorManager: AccentColorManager
    @StateObject var locationService = LocationService()
    @ObservedObject var networking: Networking
    @ObservedObject var savedLocations: SavedLocations
    @State var showAlert = false
    
    var body: some View{
        Form {
            Section {
                ZStack(alignment: .trailing) {
                    TextField("Search", text: $locationService.queryFragment)
                }
            } header: {
                Text("Search Locations")
                    .font(.headline)
                    .foregroundColor(accentColorManager.accentColor)
            }
            Section {
                List {
                    Group {
                        switch locationService.status {
                        case .noResults:  AnyView(Text("No Results"))
                        case .error(let description):  AnyView(Text("Error: \(description)"))
                        default:  AnyView(EmptyView())
                        }
                    }.foregroundColor(accentColorManager.accentColor)
                    
                    ForEach(locationService.searchResults, id: \.self) { completionResult in
                        Button("\(completionResult.city), \(completionResult.country)") {
                            networking.getCoordinate(addressString: completionResult.city) { coordinates, error in
                                if error == nil {
                                    networking.lastLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                    DispatchQueue.main.async() {
                                        let newLocation = Location(name: completionResult.city, isFrostAlertEnabled: false)
                                        
                                        savedLocations.all.append(newLocation)
                                        savedLocations.all = savedLocations.all.unique()
                                        
                                        dismiss()
                                    }
                                } else {
                                    print("Error setting custom location: \(String(describing: error))")
                                    showAlert.toggle()
                                }
                            }
                        }
                        .foregroundColor(accentColorManager.accentColor)
                        .padding()
                    }
                }
            }
        }
        .accentColor(accentColorManager.accentColor)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Location not Supported"),
            message: Text("The location you have chosen is not currently supported."),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}


