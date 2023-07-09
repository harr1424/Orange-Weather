import SwiftUI
import WeatherKit

struct DailyView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var daily: DayWeather
    
    var body: some View {
        
        if colorScheme == .light {
            DailyViewLight(daily: daily)
        }
        
        else {
            DailyViewDark(daily: daily)
        }
    }
}

struct DailyViewLight: View {
    var daily: DayWeather

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
            HStack {
                VStack{
                    Text("\(daily.date.getFormattedDate(format: "EEEE"))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Image(systemName: daily.symbolName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.5)
                        .foregroundColor(.secondary)
                        .frame(width: 100)
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Text("Hi: \(daily.highTemperature.formatted())")
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Text("Lo: \(daily.lowTemperature.formatted())")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("\(daily.condition.description)")
                        .foregroundColor(.secondary)
                    
                    Text("Wind \(daily.wind.speed.formatted()) \(daily.wind.getAbbreviatedDirections())")
                        .foregroundColor(.secondary)
                    
                    Text("UV Index \(daily.uvIndex.value) \(daily.uvIndex.category.description)")
                        .foregroundColor(.secondary)
                    
                    
                    if (Int(daily.precipitationChance.description) ?? 0 * 100) > 0 {
                        Text("\((Int(daily.precipitationChance.description) ?? 0) * 100)% chance of \(daily.precipitation.description)")
                            .foregroundColor(.secondary)
                        
                    }
                }
                
                Spacer()
                
            }
        }
    }
}

struct DailyViewDark: View {
    var daily: DayWeather

    var body: some View {
        HStack {
            VStack{
                Text("\(daily.date.getFormattedDate(format: "EEEE"))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Image(systemName: daily.symbolName)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.5)
                    .foregroundColor(.secondary)
                    .frame(width: 100)
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Text("Hi: \(daily.highTemperature.formatted())")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("Lo: \(daily.lowTemperature.formatted())")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("\(daily.condition.description)")
                    .foregroundColor(.secondary)
                
                Text("Wind \(daily.wind.speed.formatted()) \(daily.wind.getAbbreviatedDirections())")
                    .foregroundColor(.secondary)
                
                Text("UV Index \(daily.uvIndex.value) \(daily.uvIndex.category.description)")
                    .foregroundColor(.secondary)
                
                
                if (Int(daily.precipitationChance.description) ?? 0 * 100) > 0 {
                    Text("\((Int(daily.precipitationChance.description) ?? 0) * 100)% chance of \(daily.precipitation.description)")
                        .foregroundColor(.secondary)
                    
                }
            }
            
            Spacer()
            
        }
    }
}


