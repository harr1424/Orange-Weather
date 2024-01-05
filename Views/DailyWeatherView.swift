import SwiftUI
import StoreKit
import WeatherKit

struct DailyWeatherView: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var daily: Forecast<DayWeather>
    
    var body: some View {
        
        if colorScheme == .light {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                let dailyForecast = daily.forecast
                List(dailyForecast, id: \.date) { forecast in
                    DailyView(daily: forecast)
                        .listRowBackground(Color.clear)
                }
                .environment(\.defaultMinListRowHeight, 150)
                .navigationTitle("Daily")
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
                .accentColor(accentColorManager.accentColor)
            }
        } else {
            let dailyForecast = daily.forecast
            
            List(dailyForecast, id: \.date) { forecast in
                DailyView(daily: forecast)
                    .listRowBackground(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(accentColorManager.accentColor, lineWidth: 1)
                    )
            }
            .environment(\.defaultMinListRowHeight, 150)
            .navigationTitle("Daily")
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .accentColor(accentColorManager.accentColor)
        }
    }
}
