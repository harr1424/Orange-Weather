import SwiftUI
import CoreLocation

struct LocationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var networking: Networking
    @StateObject var savedLocations = SavedLocations()
    @State private var showingSheet = false
    
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
                            networking.getCoordinate(addressString: saved.name) { coordinates, error in
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
                LocationSearchView(networking: networking, savedLocations: savedLocations)
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
