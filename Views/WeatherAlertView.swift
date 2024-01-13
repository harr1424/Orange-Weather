import SwiftUI
import StoreKit
import WeatherKit

struct WeatherAlertView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var alerts: [WeatherAlert]?
    
    var body: some View {
        
        if colorScheme == .light {
            if !alerts!.isEmpty {
                WeatherAlertViewLight(alerts: alerts)
            }
            else {
                EmptyAlertListLight()
            }
        }
        
        else {
            if !alerts!.isEmpty {
                WeatherAlertViewDark(alerts: alerts)
            } else {
                EmptyAlertListDark()
            }
        }
    }
}

struct EmptyAlertListLight: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                
                Image(systemName: "smoke")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.75)
                    .foregroundColor(accentColorManager.accentColor)
                Text("There are currently no active weather alerts for your location")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                    .padding(50)
                    .multilineTextAlignment(.center)
            }
            Spacer()
                .navigationTitle("Alerts")
        }
        .accentColor(accentColorManager.accentColor)
    }
}

struct EmptyAlertListDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager

    var body: some View {
        VStack {
            Image(systemName: "smoke")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(accentColorManager.accentColor)
            Text("There are currently no active weather alerts for your location")
                .fontWeight(.bold)
                .font(.system(size: 24))
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
                .multilineTextAlignment(.center)
            Spacer()
                .navigationTitle("Alerts")
        }
        .accentColor(accentColorManager.accentColor)
    }
}

struct WeatherAlertViewLight: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    var alerts: [WeatherAlert]?
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if let currAlerts = alerts {
                List(currAlerts, id: \.summary) { alert in
                    AlertViewLight(alert: alert)
                        .listRowBackground(Color.clear)
                        .cornerRadius(10)

                }
                .navigationTitle("Alerts")
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
            }
        }
        .accentColor(accentColorManager.accentColor)
    }
}

struct WeatherAlertViewDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    var alerts: [WeatherAlert]?
    
    var body: some View {
        
        VStack {
            if let currAlerts = alerts {
                List(currAlerts, id: \.summary) { alert in
                    AlertViewDark(alert: alert)
                        .listRowBackground(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(accentColorManager.accentColor, lineWidth: 1)
                        )
                }
                .navigationTitle("Alerts")
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
            }
        }
        .accentColor(accentColorManager.accentColor)
    }
}

