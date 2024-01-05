import SwiftUI
import WeatherKit

struct HourlyView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var hourly: HourWeather
    var body: some View {
        
        if colorScheme == .light {
            HourlyViewLight(hourly: hourly)
                .cornerRadius(10)
        }
        
        else {
            HourlyViewDark(hourly: hourly)
                .cornerRadius(10)
        }
    }
}

struct HourlyViewLight: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    var hourly: HourWeather
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, accentColorManager.accentColor]),  startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: .bottom)
                .ignoresSafeArea()
            HStack {
                VStack{
                    Text("\(hourly.date.getFormattedDate(format: "E h:mm a"))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Image(systemName: hourly.symbolName)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .scaleEffect(0.9)
                        .shadow(color: accentColorManager.accentColor, radius: 30)
                        .foregroundColor(accentColorManager.accentColor)
                        .frame(width: 100, height: 100)

                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Text("\(hourly.temperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Text("\(hourly.condition.description)")
                        .foregroundColor(.secondary)
                    
                    Text("\(hourly.wind.speed.formatted(.measurement(width: .abbreviated, usage: .general, numberFormatStyle: .number.precision(.fractionLength(0))))) \(hourly.wind.getAbbreviatedDirections())")
                        .foregroundColor(.secondary)
                    
                    Text("UV \(hourly.uvIndex.value) \(hourly.uvIndex.category.description)")
                        .foregroundColor(.secondary)
                    
                    
                    if (hourly.precipitationChance * 100) > 0 {
        
                        Text("\(String(format: "%.0f", hourly.precipitationChance * 100))% \(hourly.getPrecipitationType())")
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

struct HourlyViewDark: View {
    @EnvironmentObject var accentColorManager: AccentColorManager
    var hourly: HourWeather
    
    var body: some View {
        HStack {
            VStack{
                Text("\(hourly.date.getFormattedDate(format: "E h:mm a"))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Image(systemName: hourly.symbolName)
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .scaleEffect(0.8)
                    .shadow(color: accentColorManager.accentColor, radius: 30)
                    .shadow(color: accentColorManager.accentColor, radius: 30)
                    .foregroundColor(accentColorManager.accentColor)
                    .frame(width: 100, height: 100)

                Spacer()
            }
            
            Spacer()
            
            VStack {
                Text("\(hourly.temperature.formatted(.measurement(width: .abbreviated, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("\(hourly.condition.description)")
                    .foregroundColor(.secondary)
                
                Text("\(hourly.wind.speed.formatted(.measurement(width: .abbreviated, usage: .general, numberFormatStyle: .number.precision(.fractionLength(0))))) \(hourly.wind.getAbbreviatedDirections())")
                    .foregroundColor(.secondary)
                
                
                Text("UV \(hourly.uvIndex.value) \(hourly.uvIndex.category.description)")
                    .foregroundColor(.secondary)
                
                
                if (hourly.precipitationChance * 100) > 0 {
    
                    Text("\(String(format: "%.0f", hourly.precipitationChance * 100))% \(hourly.getPrecipitationType())")
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
