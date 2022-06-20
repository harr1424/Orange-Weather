//
//  WeatherAlertView.swift
//  Orange Weather
//
//  Created by user on 6/13/22.
//

import SwiftUI

/* A View desribing any current weather alerts at a
 device location. If not alerts are active, a message
 stating so will be shown instead. */
struct WeatherAlertView: View {
    
    var alerts: [Alert]?
    
    var body: some View {
        if let currAlerts = alerts {
            List(currAlerts) { alert in
                AlertView(alert: alert)
            }
            .navigationTitle("Alerts")
            
        } else {
            Image(systemName: "smoke")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .scaleEffect(0.75)
                .foregroundColor(.blue)
            Text("There are currently no active weather alerts for your location")
                .fontWeight(.bold)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            Spacer()
                .navigationTitle("Alerts")
        }
    }
}

struct WeatherAlertView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherAlertView()
    }
}
