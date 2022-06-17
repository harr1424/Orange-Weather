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
    let calendar = Calendar.current
    var daily: Daily
    
    var uvColor: Color {
        if daily.uvi < 2 {
            return .blue
        }
        else if daily.uvi < 5 {
            return .orange
        }
        else if daily.uvi < 8 {
            return .red
        }
        else {
            return .purple
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Text("\(WeatherModel.getWeekDay(day: Int(calendar.component(.weekday, from: NSDate(timeIntervalSince1970: TimeInterval(daily.dt)) as Date))))")
                    .fontWeight(.bold)
                Spacer()
                HStack {
                Text("\(daily.temp.max, specifier: "%.0f")°F")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    Spacer()
                    Text("\(daily.temp.min, specifier: "%.0f")°F")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Max UV: \(daily.uvi, specifier: "%.0f")")
                    .foregroundColor(uvColor)
                Spacer()
            }
            Image(systemName:  WeatherModel.getConditionName(weatherID: daily.weather[0].id))
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(WeatherModel.getIconColor(weatherID: daily.weather[0].id))
            VStack {
                Spacer()
                Text("Wind \(daily.wind_speed, specifier: "%.0f") mph from \(WeatherModel.getWindDirection(degree: daily.wind_deg))")
                Spacer()
                Text("\(daily.pop * 100, specifier: "%.0f")% chance of \(WeatherModel.getRainorSnow(temp: daily.temp.min))")
                Spacer()
            }
        }
    }
}
