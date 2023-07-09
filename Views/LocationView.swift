import SwiftUI
import CoreLocation

struct LocationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var networking: Networking
    @StateObject var savedLocations = SavedLocations()
    
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
    
    var body: some View {
        NavigationView{
            VStack {
                Button{
                    networking.useCurrentLocation()
                    dismiss()
                } label: {
                    Label("Current Location", systemImage: "location.fill")
                }
                .font(.title)
                .padding()
                
                List {
                    ForEach(savedLocations.all, id: \.self) { saved in
                        Button(saved.name) {
                            getCoordinate(addressString: saved.name) { coordinates, error in
                                networking.lastLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                            }
                            dismiss()
                        }
                        .font(.title3)
                    }
                    .onDelete(perform: savedLocations.deleteLocation)
                }
            }
            .sheet(isPresented: $showingSheet) {
                LocationSearch(networking: networking)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showingSheet.toggle()
                    } label: {
                        Label("New Location", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Locations")
        }
    }
}
