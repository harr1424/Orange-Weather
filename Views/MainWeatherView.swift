
import SwiftUI
import CoreLocation
import StoreKit

struct MainWeatherView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    @StateObject var network = Networking()
    @StateObject var networkConn = NetworkStatus()
    @StateObject var storeKitManager = StoreKitManager.shared
    
    @State private var showingSheet = false
    @State private var navigationButtonID = UUID()
    
    var userEngagement = UserEngagement()
    
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
                        .task(priority: .userInitiated) {
                            await self.update()
                            if network.locationString == nil {
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
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: SettingsView(networking: network)) {
                                    Image(systemName: "gearshape")
                                        .imageScale(.large)
                                }
                            }
                        }
                        .sheet(isPresented: $showingSheet) {
                            if storeKitManager.subscriptionStatus == .subscribed{
                                LocationViewLight(networking: self.network)
                                    .onDisappear {
                                        self.navigationButtonID = UUID()
                                    }
                            }
                            else {
                                SubscriptionOptionsViewLight()
                                    .onDisappear {
                                        self.navigationButtonID = UUID()
                                    }
                            }
                        }
                        .alert(item: $storeKitManager.alert) { alertItem in
                            Alert(
                                title: Text(alertItem.title),
                                message: alertItem.message.map(Text.init),
                                dismissButton: .default(Text(alertItem.dismissButtonTitle)) {
                                    alertItem.action?()
                                }
                            )
                        }
                }
                
                
                else {
                    MainWeatherViewDark(network: network)
                        .navigationTitle(network.locationString?.locality! ?? "Loading")
                        .environmentObject(network)
                        .task(priority: .userInitiated) {
                            await self.update()
                            if network.locationString == nil {
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
                                .foregroundColor(accentColorManager.accentColor)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: SettingsView(networking: network)) {
                                    Image(systemName: "gearshape")
                                        .imageScale(.large)
                                }
                                .foregroundColor(accentColorManager.accentColor)
                            }
                        }
                        .sheet(isPresented: $showingSheet) {
                            if storeKitManager.subscriptionStatus == .subscribed{
                                LocationViewDark(networking: self.network)
                                    .onDisappear {
                                        self.navigationButtonID = UUID()
                                    }
                            }
                            else {
                                SubscriptionOptionsViewDark()
                                    .onDisappear {
                                        self.navigationButtonID = UUID()
                                    }
                            }
                        }
                        .alert(item: $storeKitManager.alert) { alertItem in
                            Alert(
                                title: Text(alertItem.title),
                                message: alertItem.message.map(Text.init),
                                dismissButton: .default(Text(alertItem.dismissButtonTitle)) {
                                    alertItem.action?()
                                }
                            )
                        }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(accentColorManager.accentColor)
        }
    }
}

struct NoNetworkView: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        Image(systemName: "antenna.radiowaves.left.and.right")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .scaleEffect(0.75)
            .shadow(color: accentColorManager.accentColor, radius: 30)
            .shadow(color: accentColorManager.accentColor, radius: 5)
            .foregroundColor(accentColorManager.accentColor)
        
        Text("""
        You currently are not connected to the internet. Please connect to Wi-Fi or cellular data in order to use this app.
        """)
        .fontWeight(.bold)
        .font(.system(size: 24))
        .foregroundColor(accentColorManager.accentColor)
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct RequestLocationPermissionsView: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        Image(systemName: "tornado")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .scaleEffect(0.75)
            .shadow(color: accentColorManager.accentColor, radius: 30)
            .shadow(color: accentColorManager.accentColor, radius: 5)
            .foregroundColor(accentColorManager.accentColor)
        Text("""
        This app requires permission to access your location while the app is in use. It will not work otherwise. Your location
        data is never shared with nor stored by the developer. Please grant location permissions to this app from the settings menu.
        """)
        .fontWeight(.bold)
        .font(.system(size: 24))
        .foregroundColor(accentColorManager.accentColor)
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct ErrorUpdatingWeatherView: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    @ObservedObject var network: Networking
    @State private var errorUpdatingWeather = true
    
    var body: some View {
        Image(systemName: "smoke")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .scaleEffect(0.75)
            .shadow(color: accentColorManager.accentColor, radius: 30)
            .shadow(color: accentColorManager.accentColor, radius: 5)
            .foregroundColor(accentColorManager.accentColor)
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
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                
                if let current = network.currentWeather{
                    Image(systemName: current.symbolName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.75)
                        .shadow(color: accentColorManager.accentColor, radius: 30)
                        .foregroundColor(accentColorManager.accentColor)
                    
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
                            Text("\(current.temperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.apparentTemperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.wind.speed.formatted()) \(current.wind.getAbbreviatedDirections())")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.humidity * 100, specifier: "%.0f") %")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("\(current.dewPoint.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
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
                            ButtonViewLight(text: "Hourly")
                        }
                        NavigationLink(destination: WeatherAlertView(alerts: network.weatherAlerts)) {
                            ButtonViewLight(text: "Alerts \(Int(network.weatherAlerts?.count ?? 0))")
                        }
                        NavigationLink(destination: DailyWeatherView(daily: (network.dailyForecast)!)) {
                            ButtonViewLight(text: "Daily")
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
        .accentColor(accentColorManager.accentColor)
    }
}

struct MainWeatherViewDark: View {
    @ObservedObject var network: Networking
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        VStack {
            
            if let current = network.currentWeather{
                Image(systemName: current.symbolName)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.75)
                    .shadow(color: accentColorManager.accentColor, radius: 30)
                    .shadow(color: accentColorManager.accentColor, radius: 5)
                    .foregroundColor(accentColorManager.accentColor)
                
                HStack {
                    
                    VStack{
                        Text("Temperature")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        Text("Feels Like")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("Wind")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("Humidity")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("Dew Point")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("Visibility")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("Barometer")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("UV Index")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Text("\(current.temperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.apparentTemperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.wind.speed.formatted()) \(current.wind.getAbbreviatedDirections())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.humidity * 100, specifier: "%.0f") %")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.dewPoint.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.visibility.formatted())")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.pressureTrend.description)")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Text("\(current.uvIndex.value) \(current.uvIndex.category.description)")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundColor(accentColorManager.accentColor)
                        
                        Spacer()
                    }
                }
                HStack {
                    NavigationLink(destination: HourlyWeatherView(hourly: network.hourlyForecast!)) {
                        ButtonViewDark(text: "Hourly")
                            .foregroundColor(accentColorManager.accentColor)
                        
                    }
                    NavigationLink(destination: WeatherAlertView(alerts: network.weatherAlerts)) {
                        ButtonViewDark(text: "Alerts \(Int(network.weatherAlerts?.count ?? 0))")
                            .foregroundColor(accentColorManager.accentColor)
                        
                    }
                    NavigationLink(destination: DailyWeatherView(daily: (network.dailyForecast)!)) {
                        ButtonViewDark(text: "Daily")
                            .foregroundColor(accentColorManager.accentColor)
                        
                    }
                }
                Spacer()
                HStack{
                    Label("Apple Weather", systemImage: "apple.logo")
                        .foregroundColor(accentColorManager.accentColor)
                    
                    Link("Data Sources", destination: URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/")!)
                        .foregroundColor(accentColorManager.accentColor)
                    
                    
                }
            }
        }
        .accentColor(accentColorManager.accentColor)
    }
}
