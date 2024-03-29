import SwiftUI
import StoreKit
import WeatherKit

struct HourlyWeatherView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var accentColorManager: AccentColorManager
    var hourly: Forecast<HourWeather>
    
    var body: some View {
        
        if colorScheme == .light {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                let hourlyForecast = hourly.futureElements()
                List(hourlyForecast, id: \.date) { forecast in
                    HourlyView(hourly: forecast)
                        .listRowBackground(Color.clear)
                }
                .environment(\.defaultMinListRowHeight, 150)
                .navigationTitle("Hourly")
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
                .accentColor(accentColorManager.accentColor)
            }
        } else {
            
            let hourlyForecast = hourly.futureElements()
            
            List(hourlyForecast, id: \.date) { forecast in
                HourlyView(hourly: forecast)
                    .listRowBackground(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(accentColorManager.accentColor, lineWidth: 1)
                    )
            }
            .environment(\.defaultMinListRowHeight, 150)
            .navigationTitle("Hourly")
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .accentColor(accentColorManager.accentColor)
        }
    }
}
