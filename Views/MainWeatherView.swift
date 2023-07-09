
import SwiftUI
import CoreLocation
import StoreKit

struct MainWeatherView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.requestReview) var requestReview
    
    @StateObject var network = Networking()
    @StateObject var networkConn = NetworkStatus()
    
    var userEngagement = UserEngagement()
    
    @State private var showingSheet = false
    @State private var navigationButtonID = UUID()
    
    var lat: CLLocationDegrees {
        return self.network.lastLocation?.coordinate.latitude ?? 0
    }
    
    var lon: CLLocationDegrees {
        return self.network.lastLocation?.coordinate.longitude ?? 0
    }
    
    public func update() async {
        await self.network.getWeather()
    }
    
    var body: some View {
        
        // If a user is not connected to the internet
        if !networkConn.isConnected {
            NoNetworkView()
        }
        
        // If a user has not granted location permissions while the app is in use
        else if !network.permissions {
            RequestLocationPermissionsView()
        }
        
        // uf a chosen location has a valid CLLocation, but WeatherKit does not provide a valid response
        else if network.errorUpdatingWeather {
            ErrorUpdatingWeatherView(network: network)
        }

        else {
            NavigationView {
                
                if colorScheme == .light{
                    MainWeatherViewLight(network: network)
                    .navigationTitle(network.locationString?.locality! ?? "Loading")
                    .environmentObject(network)
                    .task {
                        await self.update()
                        if lat == 0 && lon == 0 {
                            await self.update()
                        }
                        userEngagement.points += 1
                        UserDefaults.standard.set(userEngagement.points, forKey: "Points")
                        if userEngagement.points > 50 {
                            DispatchQueue.main.async {
                                requestReview()
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Locations") {
                                showingSheet.toggle()
                            }
                            .id(self.navigationButtonID)
                        }
                    }
                    .sheet(isPresented: $showingSheet) {
                        LocationView(networking: self.network)
                            .onDisappear {
                                self.navigationButtonID = UUID()
                            }
                    }
                }
                
                else {
                    MainWeatherViewDark(network: network)
                    .navigationTitle(network.locationString?.locality! ?? "Loading")
                    .environmentObject(network)
                    .task {
                        await self.update()
                        if lat == 0 && lon == 0 {
                            await self.update()
                        }
                        userEngagement.points += 1
                        UserDefaults.standard.set(userEngagement.points, forKey: "Points")
                        if userEngagement.points > 50 {
                            DispatchQueue.main.async {
                                requestReview()
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Locations") {
                                showingSheet.toggle()
                            }
                            .id(self.navigationButtonID)
                        }
                    }
                    .sheet(isPresented: $showingSheet) {
                        LocationView(networking: self.network)
                            .onDisappear {
                                self.navigationButtonID = UUID()
                            }
                    }
                }
            }
        }
    }
}

struct NoNetworkView: View {
    var body: some View {
        Image(systemName: "antenna.radiowaves.left.and.right")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .scaleEffect(0.75)
            .foregroundColor(.orange)
        Text("""
        You currently are not connected to the internet. Please connect to Wi-Fi or cellular data in order to use this app.
        """)
        .fontWeight(.bold)
        .font(.system(size: 24))
        .foregroundColor(.blue)
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct RequestLocationPermissionsView: View {
    var body: some View {
        Image(systemName: "tornado")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .scaleEffect(0.75)
            .foregroundColor(.orange)
        Text("""
        This app requires permission to access your location while the app is in use. It will not work otherwise. Your location
        data is never shared with nor stored by the developer. Please grant location permissions to this app from the settings menu.
        """)
        .fontWeight(.bold)
        .font(.system(size: 24))
        .foregroundColor(.orange)
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct ErrorUpdatingWeatherView: View {
    @ObservedObject var network: Networking
    @State private var errorUpdatingWeather = true
    
    var body: some View {
        Image(systemName: "smoke")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .scaleEffect(0.75)
            .foregroundColor(.orange)
            .alert(isPresented: $errorUpdatingWeather) {
                Alert(title: Text("Location not Supported"),
                      message: Text("The location you have chosen is not currently supported by Apple WeatherKit."),
                      dismissButton: .default(Text("OK")) {
                    network.useCurrentLocation()
                }
                )
            }
    }
}

struct MainWeatherViewLight: View {
    @ObservedObject var network: Networking

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                
                if let current = network.currentWeather{
                    Image(systemName: current.symbolName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.75)
                        .foregroundColor(.orange)
                    
                    HStack {
                        
                        VStack{
                            Text("Temperature")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Feels Like")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Wind")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Humidity")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Dew Point")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Visibility")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Barometer")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("UV Index")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Spacer()
                        }
                        
                        VStack {
                            Text("\(current.temperature.formatted())")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.apparentTemperature.formatted())")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.wind.speed.formatted()) \(current.wind.getAbbreviatedDirections())")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.humidity * 100, specifier: "%.0f") %")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.dewPoint.formatted())")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.visibility.formatted())")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.pressureTrend.description)")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.uvIndex.value) \(current.uvIndex.category.description)")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Spacer()
                        }
                    }
                    HStack {
                        NavigationLink(destination: HourlyWeatherView(hourly: network.hourlyForecast!)) {
                            ButtonView(text: "Hourly")
                        }
                        NavigationLink(destination: WeatherAlertView(alerts: network.weatherAlerts)) {
                            ButtonView(text: "Alerts \(Int(network.weatherAlerts?.count ?? 0))")
                        }
                        NavigationLink(destination: DailyWeatherView(daily: (network.dailyForecast)!)) {
                            ButtonView(text: "Daily")
                        }
                    }
                    Spacer()
                    HStack{
                        Label("Apple Weather", systemImage: "apple.logo")
                        Link("Data Sources", destination: URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/")!)
                    }
                }
            }
        }
    }
}

struct MainWeatherViewDark: View {
    @ObservedObject var network: Networking

    var body: some View {
        VStack {
            
            if let current = network.currentWeather{
                Image(systemName: current.symbolName)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.75)
                    .foregroundColor(.secondary)
                
                HStack {
                    
                    VStack{
                        Text("Temperature")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        Text("Feels Like")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("Wind")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("Humidity")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("Dew Point")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("Visibility")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("Barometer")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("UV Index")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Text("\(current.temperature.formatted())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.apparentTemperature.formatted())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.wind.speed.formatted()) \(current.wind.getAbbreviatedDirections())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.humidity * 100, specifier: "%.0f") %")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.dewPoint.formatted())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.visibility.formatted())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.pressureTrend.description)")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Text("\(current.uvIndex.value) \(current.uvIndex.category.description)")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
                HStack {
                    NavigationLink(destination: HourlyWeatherView(hourly: network.hourlyForecast!)) {
                        ButtonView(text: "Hourly")
                            .foregroundColor(.gray)
                        
                    }
                    NavigationLink(destination: WeatherAlertView(alerts: network.weatherAlerts)) {
                        ButtonView(text: "Alerts \(Int(network.weatherAlerts?.count ?? 0))")
                            .foregroundColor(.gray)
                        
                    }
                    NavigationLink(destination: DailyWeatherView(daily: (network.dailyForecast)!)) {
                        ButtonView(text: "Daily")
                            .foregroundColor(.gray)
                        
                    }
                }
                Spacer()
                HStack{
                    Label("Apple Weather", systemImage: "apple.logo")
                        .foregroundColor(.secondary)
                    
                    Link("Data Sources", destination: URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/")!)
                    
                }
            }
        }
    }
}
