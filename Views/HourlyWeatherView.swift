import SwiftUI
import StoreKit
import WeatherKit

struct HourlyWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.requestReview) var requestReview
    
    var userEngagement = UserEngagement()
    
    var hourly: Forecast<HourWeather>
    
    var body: some View {
        
        if colorScheme == .light {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                    .ignoresSafeArea()
                
                let hourlyForecast = hourly.forecast
                List(hourlyForecast, id: \.date) { forecast in
                    HourlyView(hourly: forecast)
                }
                .navigationTitle("Hourly")
                .onAppear{
                    userEngagement.points += 1
                    UserDefaults.standard.set(userEngagement.points, forKey: "Points")
                    if userEngagement.points > 50 {
                        DispatchQueue.main.async {
                            requestReview()
                        }
                    }
                }
            }
        } else {
            let hourlyForecast = hourly.forecast
            List(hourlyForecast, id: \.date) { forecast in
                HourlyView(hourly: forecast)
            }
            .navigationTitle("Hourly")
            .onAppear{
                userEngagement.points += 1
                UserDefaults.standard.set(userEngagement.points, forKey: "Points")
                if userEngagement.points > 50 {
                    DispatchQueue.main.async {
                        requestReview()
                    }
                }
            }
        }
    }
}
