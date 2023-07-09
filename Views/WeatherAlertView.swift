import SwiftUI
import StoreKit
import WeatherKit

struct WeatherAlertView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.requestReview) var requestReview
    
    var userEngagement = UserEngagement()
    
    var alerts: [WeatherAlert]?
    
    var body: some View {
        
        if colorScheme == .light {
            
            if !alerts!.isEmpty {
                
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                        .ignoresSafeArea()
                    
                    if let currAlerts = alerts {
                        List(currAlerts, id: \.detailsURL) { alert in
                            AlertView(alert: alert)
                        }
                        .navigationTitle("Alerts")
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
            
            else {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                        .ignoresSafeArea()
                    
                    VStack{
                        
                        Image(systemName: "smoke")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .scaleEffect(0.75)
                            .foregroundColor(.orange)
                        Text("There are currently no active weather alerts for your location")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .foregroundStyle(.secondary)
                            .padding(50)
                            .multilineTextAlignment(.center)
                        }
                    Spacer()
                        .navigationTitle("Alerts")
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
        
        else {
            
            if !alerts!.isEmpty {
                
                if let currAlerts = alerts {
                    List(currAlerts, id: \.detailsURL) { alert in
                        AlertView(alert: alert)
                    }
                    .navigationTitle("Alerts")
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
                VStack {
                    Image(systemName: "smoke")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.75)
                        .foregroundColor(.orange)
                    Text("There are currently no active weather alerts for your location")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundStyle(.secondary)
                        .padding(50)
                        .background(.ultraThinMaterial)
                        .multilineTextAlignment(.center)
                    Spacer()
                        .navigationTitle("Alerts")
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
    }
}
