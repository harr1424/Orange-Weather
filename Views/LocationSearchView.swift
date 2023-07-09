import SwiftUI
import CoreLocation

struct LocationSearchView: View {
    @Environment(\.dismiss) var dismiss
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
            }
            Section {
                List {
                    Group {
                        switch locationService.status {
                        case .noResults:  AnyView(Text("No Results"))
                        case .error(let description):  AnyView(Text("Error: \(description)"))
                        default:  AnyView(EmptyView())
                        }
                    }.foregroundColor(Color.secondary)
                    
                    ForEach(locationService.searchResults, id: \.self) { completionResult in
                        Button("\(completionResult.city), \(completionResult.country)") {
                            networking.getCoordinate(addressString: completionResult.city) { coordinates, error in
                                if error == nil {
                                    networking.lastLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                    DispatchQueue.main.async() {
                                        let newLocation = Location(name: completionResult.city)
                                        
                                        // UPDATES not always reflected when sheet is dismissed
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
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Location not Supported"),
            message: Text("The location you have chosen is not currently supported."),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}


