import SwiftUI
import CoreLocation

struct LocationSearch: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var locationService = LocationService()
    @ObservedObject var networking: Networking
    var savedLocations = SavedLocations()
    
    @State private var showingSheet = false
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    var body: some View{
        Form {
            Section(header: Text("Search Locations")) {
                ZStack(alignment: .trailing) {
                    TextField("Search", text: $locationService.queryFragment)
                    
                }
            }
            Section(header: Text("Results")) {
                List {
                    Group { () -> AnyView in
                        switch locationService.status {
                        case .noResults: return AnyView(Text("No Results"))
                        case .error(let description): return AnyView(Text("Error: \(description)"))
                        default: return AnyView(EmptyView())
                        }
                    }.foregroundColor(Color.gray)
                    
                    ForEach(locationService.searchResults, id: \.self) { completionResult in
                        Button(completionResult.title) {
                            getCoordinate(addressString: completionResult.title) { coordinates, error in
                                if error == nil {
                                    networking.lastLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        let newLocation = Location(name: networking.locationString!.locality!)
                                        savedLocations.all.append(newLocation)
                                        savedLocations.all = savedLocations.all.unique()
                                        dismiss()
                                    }
                                } else {
                                    print("Error setting custom location: \(String(describing: error))")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

