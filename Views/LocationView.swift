import SwiftUI
import CoreLocation

struct LocationViewLight: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var accentColorManager: AccentColorManager
    @ObservedObject var networking: Networking
    @StateObject var savedLocations = SavedLocations()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Button {
                        networking.useCurrentLocation()
                        dismiss()
                    } label: {
                        Label("Current Location", systemImage: "location.fill")
                            .foregroundColor(accentColorManager.accentColor)
                    }
                    .font(.title)
                    .padding()
                    
                    
                    List {
                        ForEach(savedLocations.all, id: \.self) { saved in
                            Button(action: {
                                networking.getCoordinate(addressString: saved.name) { coordinates, error in
                                    networking.lastLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                }
                                dismiss()
                            }) {
                                Text(saved.name)
                                    .foregroundColor(Color.primary)
                                    .font(.title3)
                            }
                            .padding()
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteLocation)
                    }
                    .listRowBackground(Color.clear)
                    .scrollContentBackground(.hidden)
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
            }
            .navigationTitle("Locations")
            .accentColor(accentColorManager.accentColor)
        }
    }
    
    func deleteLocation(at offsets: IndexSet) {
        for offset in offsets {
            let location = savedLocations.all[offset]
            networking.deleteLocation(location: location)
            savedLocations.all.remove(at: offset)
        }
    }
}

struct LocationViewDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    @Environment(\.dismiss) var dismiss
    @ObservedObject var networking: Networking
    @StateObject var savedLocations = SavedLocations()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView{
            
            VStack {
                Button {
                    networking.useCurrentLocation()
                    dismiss()
                } label: {
                    Label("Current Location", systemImage: "location.fill")
                        .foregroundColor(accentColorManager.accentColor)
                }
                .font(.title)
                .padding()
                
                
                List {
                    ForEach(savedLocations.all, id: \.self) { saved in
                        Button(action: {
                            networking.getCoordinate(addressString: saved.name) { coordinates, error in
                                networking.lastLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                            }
                            dismiss()
                        }) {
                            Text(saved.name)
                                .foregroundColor(accentColorManager.accentColor)
                                .font(.title3)
                        }
                        .padding()
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteLocation)
                }
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
            }
            .sheet(isPresented: $showingSheet) {
                LocationSearchView(networking: networking, savedLocations: savedLocations)
            }
            .accentColor(Color.secondary)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(accentColorManager.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Locations")
            .accentColor(accentColorManager.accentColor)
        }
    }
    
    
    func deleteLocation(at offsets: IndexSet) {
        for offset in offsets {
            let location = savedLocations.all[offset]
            networking.deleteLocation(location: location)
            savedLocations.all.remove(at: offset)
        }
    }
}
