import SwiftUI
import WeatherKit

struct HourlyView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var hourly: HourWeather
    
    var body: some View {
        
        if colorScheme == .light {
            HourlyViewLight(hourly: hourly)
        }
        
        else {
            HourlyViewDark(hourly: hourly)
        }
    }
}

struct HourlyViewLight: View {
    var hourly: HourWeather
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
            HStack {
                VStack{
                    Text("\(hourly.date.getFormattedDate(format: "E h:mm a"))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Image(systemName: hourly.symbolName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.5)
                        .foregroundColor(.secondary)
                        .frame(width: 100)
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Text("\(hourly.temperature.formatted())")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Text("\(hourly.condition.description)")
                        .foregroundColor(.secondary)
                    
                    Text("Wind \(hourly.wind.speed.formatted()) \(hourly.wind.getAbbreviatedDirections())")
                        .foregroundColor(.secondary)
                    
                    Text("UV Index \(hourly.uvIndex.value) \(hourly.uvIndex.category.description)")
                        .foregroundColor(.secondary)
                    
                    
                    if (Int(hourly.precipitationChance.description) ?? 0 * 100) > 0 {
                        Text("\((Int(hourly.precipitationChance.description) ?? 0) * 100)% chance of \(hourly.precipitation.description)")
                            .foregroundColor(.secondary)
                        
                    }
                }
                
                Spacer()
                
            }
        }
    }
}

struct HourlyViewDark: View {
    var hourly: HourWeather
    
    var body: some View {
        HStack {
            VStack{
                Text("\(hourly.date.getFormattedDate(format: "E h:mm a"))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Image(systemName: hourly.symbolName)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.5)
                    .foregroundColor(.secondary)
                    .frame(width: 100)
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Text("\(hourly.temperature.formatted())")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("\(hourly.condition.description)")
                    .foregroundColor(.secondary)
                
                Text("Wind \(hourly.wind.speed.formatted()) \(hourly.wind.getAbbreviatedDirections())")
                    .foregroundColor(.secondary)
                
                Text("UV Index \(hourly.uvIndex.value) \(hourly.uvIndex.category.description)")
                    .foregroundColor(.secondary)
                
                
                if (Int(hourly.precipitationChance.description) ?? 0 * 100) > 0 {
                    Text("\((Int(hourly.precipitationChance.description) ?? 0) * 100)% chance of \(hourly.precipitation.description)")
                        .foregroundColor(.secondary)
                    
                }
            }
            
            Spacer()
            
        }
    }
}
