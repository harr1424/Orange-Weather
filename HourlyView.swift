//
//  HourlyView.swift
//  Orange Weather
//
//  Created by user on 6/15/22.
//

import SwiftUI

struct HourlyView: View {
    let calendar = Calendar.current
    var hourly: Hourly
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Text("\(WeatherModel.getWeekDay(day: Int(calendar.component(.weekday, from: NSDate(timeIntervalSince1970: TimeInterval(hourly.dt)) as Date))))")
                    .fontWeight(.bold)
                Text("\(WeatherModel.getTimeAs12hr(hour: Int(calendar.component(.hour, from: NSDate(timeIntervalSince1970: TimeInterval(hourly.dt)) as Date))))")
                    .fontWeight(.bold)
                Spacer()
                Text("\(hourly.temp, specifier: "%.0f")°F")
                    .fontWeight(.bold)
                Spacer()
            }
            Image(systemName:  WeatherModel.getConditionName(weatherID: hourly.weather[0].id))
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(WeatherModel.getIconColor(weatherID: hourly.weather[0].id))
            VStack {
                Spacer()
                Text("Wind \(hourly.wind_speed, specifier: "%.0f") mph from \(WeatherModel.getWindDirection(degree: hourly.wind_deg))")
                Spacer()
                Text("\(hourly.pop * 100, specifier: "%.0f")% chance of \(WeatherModel.getRainorSnow(temp: hourly.temp))")
                Spacer()
            }
        }
    }
}
