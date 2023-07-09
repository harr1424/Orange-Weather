import SwiftUI
import StoreKit
import WeatherKit

struct HourlyWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
        
    var hourly: Forecast<HourWeather>
    
    var body: some View {
        
        if colorScheme == .light {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                    .ignoresSafeArea()
                
                let hourlyForecast = hourly.futureElements()
                
                List(hourlyForecast, id: \.date) { forecast in
                        HourlyView(hourly: forecast)
                }
                .navigationTitle("Hourly")
            }
        } else {
            
            let hourlyForecast = hourly.futureElements()
            
            List(hourlyForecast, id: \.date) { forecast in
                HourlyView(hourly: forecast)
            }
            .navigationTitle("Hourly")
        }
    }
}
