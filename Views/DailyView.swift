import SwiftUI
import WeatherKit

struct DailyView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var daily: DayWeather
    var body: some View {
        
        if colorScheme == .light {
            DailyViewLight(daily: daily)
                .cornerRadius(10)
        }
        
        else {
            DailyViewDark(daily: daily)
                .cornerRadius(10)
        }
    }
}

struct DailyViewLight: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    var daily: DayWeather

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]),  startPoint: UnitPoint(x: 0.3, y: 0.4), endPoint: .bottom)
                .ignoresSafeArea()

            HStack {
                VStack{
                    Text("\(daily.date.getFormattedDate(format: "EEEE"))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Image(systemName: daily.symbolName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.9)
                        .foregroundColor(accentColorManager.accentColor)
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Text("Hi: \(daily.highTemperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)

                    Text("Lo: \(daily.lowTemperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)

                    Text("\(daily.wind.speed.formatted(.measurement(width: .abbreviated, usage: .general, numberFormatStyle: .number.precision(.fractionLength(0))))) \(daily.wind.getAbbreviatedDirections())")
                        .foregroundColor(.secondary)
                    
                    Text("UV \(daily.uvIndex.value) \(daily.uvIndex.category.description)")
                        .foregroundColor(.secondary)
                    
                    
                    if (daily.precipitationChance * 100) > 0 {
        
                        Text("\(String(format: "%.0f", daily.precipitationChance * 100))% \(daily.getPrecipitationType())")
                            .foregroundColor(.secondary)
                        
                    }
                }
            }
            .padding()
        }
        .frame(height: 150)
        .background(Blur(style: .systemMaterial))
        .accentColor(accentColorManager.accentColor)
    }
}

struct DailyViewDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    var daily: DayWeather

    var body: some View {
        HStack {
            VStack{
                Text("\(daily.date.getFormattedDate(format: "EEEE"))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Image(systemName: daily.symbolName)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.9)
                    .foregroundColor(accentColorManager.accentColor)
                    .padding(.leading)
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Text("Hi: \(daily.highTemperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("Lo: \(daily.lowTemperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("\(daily.wind.speed.formatted(.measurement(width: .abbreviated, usage: .general, numberFormatStyle: .number.precision(.fractionLength(0))))) \(daily.wind.getAbbreviatedDirections())")
                    .foregroundColor(.secondary)
                
                Text("UV \(daily.uvIndex.value) \(daily.uvIndex.category.description)")
                    .foregroundColor(.secondary)
                
                
                if (daily.precipitationChance * 100) > 0 {
    
                    Text("\(String(format: "%.0f", daily.precipitationChance * 100))% \(daily.getPrecipitationType())")
                        .foregroundColor(.secondary)
                    
                }
            }
            .padding()
        }
        .padding()
        .frame(height: 150)
        .background(Blur(style: .systemMaterialDark))
        .accentColor(accentColorManager.accentColor)
    }
}

