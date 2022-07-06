//
//  DailyView.swift
//  Orange Weather
//
//  Created by user on 6/15/22.
//

import SwiftUI

/* A View used to display weather infromation specific to a given day.
 Multiple DailyView Views will be displayed in a list. */
struct DailyView: View {
    
    @AppStorage("Units") var units = (UserDefaults.standard.string(forKey: "Units") ?? "imperial")

    let calendar = Calendar.current
    var daily: Daily
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Text("\(WeatherModel.getWeekDay(day: Int(calendar.component(.weekday, from: NSDate(timeIntervalSince1970: TimeInterval(daily.dt)) as Date))))")
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    if units == "imperial" {
                Text("\(daily.temp.max, specifier: "%.0f")°F")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    Spacer()
                    Text("\(daily.temp.min, specifier: "%.0f")°F")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    } else {
                        Text("\(WeatherModel.fahrenheitToCelsius(degreesF: daily.temp.max) , specifier: "%.0f")°C")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            Spacer()
                        Text("\(WeatherModel.fahrenheitToCelsius(degreesF: daily.temp.min) , specifier: "%.0f")°C")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                    }
                }
                Spacer()
                Text("Max UV: \(daily.uvi, specifier: "%.0f")")
                    .foregroundColor(WeatherModel.getUvColor(uvIndex: daily.uvi))
                Spacer()
            }
            Image(systemName:  WeatherModel.getConditionName(weatherID: daily.weather[0].id))
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(WeatherModel.getIconColor(weatherID: daily.weather[0].id))
            VStack {
                Spacer()
                if units == "imperial" {
                Text("Wind \(daily.wind_speed, specifier: "%.0f") mph \(WeatherModel.getWindDirection(degree: daily.wind_deg))")
                } else {
                    Text("Wind \(WeatherModel.mphToKmh(speedMph: daily.wind_speed) , specifier: "%.0f") kmh \(WeatherModel.getWindDirection(degree: daily.wind_deg))")
                }
                Spacer()
                Text("\(daily.pop * 100, specifier: "%.0f")% chance of \(WeatherModel.getRainorSnow(temp: daily.temp.min))")
                Spacer()
            }
        }
    }
}
