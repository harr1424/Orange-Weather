import SwiftUI
import StoreKit
import WeatherKit

struct DailyWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.requestReview) var requestReview
    
    var userEngagement = UserEngagement()
    
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
            let dailyForecast = daily.forecast
            List(dailyForecast, id: \.date) { forecast in
                DailyView(daily: forecast)
            }
            .navigationTitle("Daily")
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
