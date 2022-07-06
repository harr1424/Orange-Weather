//
//  HourlyView.swift
//  Orange Weather
//
//  Created by user on 6/14/22.
//

import SwiftUI

/* A View describing the hourly forecast for a given location. */
struct HourlyWeatherView: View {
    
    var hourly: [Hourly]?
    
    var body: some View {
        if let currHourly = hourly {
            List(currHourly) { forecast in
                HourlyView(hourly: forecast)
            }
            .navigationTitle("Hourly")
            
        } else {
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.5)
                .foregroundColor(.blue)
            Text("Something went wrong... Please try again in a moment.")
                .fontWeight(.bold)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            Spacer()
                .navigationTitle("Hourly")
        }
    }
}

struct HourlyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherView()
    }
}
