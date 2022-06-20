//
//  DailyWeatherView.swift
//  Orange Weather
//
//  Created by user on 6/14/22.
//

import SwiftUI

/* A View describing the daily forecast for a given location. */
struct DailyWeatherView: View {
    
    var daily: [Daily]?
    
    var body: some View {
        if let currDaily = daily {
            List(currDaily) { forecast in
                DailyView(daily: forecast)
            }
            .navigationTitle("Daily")
            
        } else {
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(.blue)
            Text("Something went wrong... ")
                .fontWeight(.bold)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            Spacer()
                .navigationTitle("Daily")
        }
    }
}


struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView()
    }
}
