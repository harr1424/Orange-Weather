//
//  ContentView.swift
//  Orange Weather
//
//  Created by user on 6/11/22.
//

import SwiftUI
import CoreLocation

/* The initial View shown in the application. From here, a user
 is able to see current weather information as well as navigate to other
 views of the app. If a user is not connected to the internet, or
 has not granted location permissions to this app, the view will
 display an error message. */
struct MainWeatherView: View {
    
    /* State objects are used here as opposed to ObservedObjetcs since
     these objects are being instantiated in this class*/
    @StateObject var network = Networking()  // object containing location and weather information
    @StateObject var networkConn = NetworkStatus()  // object containing network connectivity status
        
    var lat: CLLocationDegrees {
        return self.network.lastLocation?.coordinate.latitude ?? 0
    }
    
    var lon: CLLocationDegrees {
        return self.network.lastLocation?.coordinate.longitude ?? 0
    }
    
    var locationString: String {
        return self.network.locationString?.name ?? "Orange Weather"
    }
    
    func update(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        self.network.getLocationString(lat, lon)
        self.network.getMainWeather(lat, lon)
        self.network.getAQI(lat, lon)
    }
    
    
    var body: some View {
        
        // If a user is not connected to the internet
        if !networkConn.isConnected {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(.blue)
            Text("""
            You currently are not connected to the internet. Please connect to Wi-Fi or cellular data in order to use this app.
            """)
            .fontWeight(.bold)
            .font(.system(size: 24))
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .padding()
        }
        
        // If a user has not granted location permissions while the app is in use
        else if !network.permissions {
            Image(systemName: "tornado")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(.blue)
            Text("""
            This app requires permission to access your location while the app is in use. It will not work otherwise. Your location
            data is never shared with nor stored by the developer. Please grant location permissions to this app from the settings menu.
            """)
            .fontWeight(.bold)
            .font(.system(size: 24))
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .padding()
            
        } else {  // Display the intended view
            
            NavigationView {
                VStack {
                    if let response = network.weatherResponse {
                        Image(systemName: WeatherModel.getConditionName(weatherID: (response.current.weather[0].id)))
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .scaleEffect(0.75)
                            .foregroundColor(WeatherModel.getIconColor(weatherID: response.current.weather[0].id))
                    }
                    
                    HStack {
                        
                        VStack{
                            Text("Temperature")
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
                            Text("UV Index")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Text("Air Quality")
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Spacer()
                        }
                        
                        VStack {
                            if let response = network.weatherResponse {
                                Text("\(response.current.temp, specifier: "%.0f")°F")
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                                Text("\(response.current.wind_speed, specifier: "%.0f") mph from \(WeatherModel.getWindDirection(degree: response.current.wind_speed))")
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                                Text("\(response.current.humidity, specifier: "%.0f") %")
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                                Text("\(response.current.dew_point, specifier: "%.2f") °F")
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                                Text("\(response.current.uvi, specifier: "%.0f")  \(WeatherModel.getUvIndexCategory(uvIndex: response.current.uvi))")
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                            }
                            if let response = network.currAQI {
                                Text(WeatherModel.getAQIstring(aqi: response.list[0].main.aqi))
                                    .fontWeight(.bold)
                                    .font(.system(size: 24))
                            }
                            Spacer()
                        }
                    }
                    HStack {
                        NavigationLink(destination: HourlyWeatherView(hourly: network.weatherResponse?.hourly)) {
                            ButtonView(text: "Hourly")
                        }
                        NavigationLink(destination: WeatherAlertView(alerts: network.weatherResponse?.alerts)) {
                            ButtonView(text: "Alerts")
                        }
                        NavigationLink(destination: DailyWeatherView(daily: network.weatherResponse?.daily)) {
                            ButtonView(text: "Daily")
                        }
                    }
                }
                .navigationTitle(locationString)
                .environmentObject(network)
                .onAppear {
                    /* Depending upon netowrk latency, the weather information, location string, and air quality index
                     may not have been retrieved and/or decoded by the time the view appears. If lat and lon are still nil,
                     update the UI*/
                    if lat == 0 && lon == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.update(lat: lat, lon: lon)
                        })
                    }
                    self.update(lat: lat, lon: lon)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView()
            .preferredColorScheme(.dark)
    }
}
