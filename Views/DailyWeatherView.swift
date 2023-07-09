import SwiftUI
import StoreKit
import WeatherKit

struct DailyWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
        
    var daily: Forecast<DayWeather>
    
    var body: some View {
        
        if colorScheme == .light {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                    .ignoresSafeArea()
                
                let dailyForecast = daily.forecast
                List(dailyForecast, id: \.date) { forecast in
                    DailyView(daily: forecast)
                }
                .navigationTitle("Daily")
            }
        } else {
            let dailyForecast = daily.forecast
            List(dailyForecast, id: \.date) { forecast in
                DailyView(daily: forecast)
            }
            .navigationTitle("Daily")
        }
    }
}
