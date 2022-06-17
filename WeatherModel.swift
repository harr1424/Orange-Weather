//
//  MainWeatherNetworking.swift
//  Orange Weather
//
//  Created by user on 6/11/22.
//

import Foundation
import CoreLocation
import SwiftUI

/* This struct contains helper methods useful for formatting weather information and
 for programmatically enhancing the UI*/
struct WeatherModel {
    
    /* Given an integer representing a weather condition,
     will return a String corresponding to an SF Symbol to be displayed. */
    static func getConditionName(weatherID: Int) -> String {
        switch weatherID {
        case 200..<300:
            return "cloud.bolt.rain.fill"
        case 300..<400:
            return "cloud.drizzle.fill"
        case 500..<600:
            return "cloud.rain.fill"
        case 600..<700:
            return "cloud.snow.fill"
        case 701:
            return "cloud.fog.fill"
        case 711:
            return "smoke.fill"
        case 721:
            return "sun.haze.fill"
        case 731:
            return "sun.dust.fill"
        case 741:
            return "cloud.fog.fill"
        case 751:
            return "sun.dust.fill"
        case 761:
            return "sun.dust.fill"
        case 762:
            return "sun.dust.fill"
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800...802:
            return "sun.max.fill"
        case 803...804:
            return "cloud.sun.fill"
        default:
            return "questionmark"
        }
    }
    
    /* Given an integer representing a weather condition, will return
     a color used to color an SF Symbol. */
    static func getIconColor(weatherID: Int) -> Color {
        if weatherID < 721 {
            return .gray
        } else if weatherID < 770 {
            return .yellow
        } else if weatherID == 771 {
            return .blue
        } else if weatherID == 791{
            return .brown
        } else if weatherID >= 800 && weatherID <= 802 {
            return .yellow
        } else {
            return .blue
        }
    }
    
    /* Given a Double corresponding to a Ultra Violet Index, will return
     a String describing the intensity of the current index. */
    static func getUvIndexCategory(uvIndex: Double) -> String {
        if uvIndex < 2 {
            return "Low"
        } else if uvIndex >= 2 && uvIndex < 5{
            return "Moderate"
        } else if uvIndex >= 5 && uvIndex < 8 {
            return "High"
        } else if uvIndex >= 8 {
            return "Extreme"
        } else {
            return "UV Index Not Available"
        }
    }
    
    /* Given a Double describing a wind direction in degrees, will return a String
     representation of the wind direction using cardinal direction abbreviations. */
    static func getWindDirection(degree: Double) -> String {
        let val = floor((degree / 22.5) + 0.5)
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        return directions[Int(val.truncatingRemainder(dividingBy: 16))]
    }
    
    /* Given an Integer representing the current Air Quality Index, will return
     a String description of the current index. */
    static func getAQIstring(aqi: Int) -> String {
        switch aqi {
        case 1: return "Good"
        case 2: return "Fair"
        case 3: return "Moderate"
        case 4: return "Poor"
        case 5: return "Very Poor"
        default: return "Not Available"
        }
    }
    
    /* Given an Integer representing the hour of a day in 24 hour format,
     will return a String representation of the time in 12 hour format. */
    static func getTimeAs12hr(hour: Int) -> String {
        switch hour {
        case 0: return "12:00 AM"
        case 1: return "1:00 AM"
        case 2: return "2:00 AM"
        case 3: return "3:00 AM"
        case 4: return "4:00 AM"
        case 5: return "5:00 AM"
        case 6: return "6:00 AM"
        case 7: return "7:00 AM"
        case 8: return "8:00 AM"
        case 9: return "9:00 AM"
        case 10: return "10:00 AM"
        case 11: return "11:00 AM"
        case 12: return "12:00 PM"
        case 13: return "1:00 PM"
        case 14: return "2:00 PM"
        case 15: return "3:00 PM"
        case 16: return "4:00 PM"
        case 17: return "5:00 PM"
        case 18: return "6:00 PM"
        case 19: return "7:00 PM"
        case 20: return "8:00 PM"
        case 21: return "9:00 PM"
        case 22: return "10:00 PM"
        case 23: return "11:00 PM"
        case 24: return "12:00 AM"
        default: return "???"
        }
    }
    
    /* Given an Integer representing the day of the week, will return a
     String describing the week day as a proper noun. */
    static func getWeekDay(day: Int) -> String {
        switch day {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "???"
        }
    }
    
    /*  Given a Double representing a temperature, will return a String
     appropriate to the most likely form of precipitation considering
     the temperature. */
    static func getRainorSnow(temp: Double) -> String {
        if temp < 40.0 {
            return "snow"
        } else {
            return "rain"
        }
    }
    
}

/* The following structs are used to decode the JSON responses from the API*/

struct WeatherResponse: Decodable{
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let alerts: [Alert]?
}

struct Current: Decodable {
    let temp: Double
    let humidity: Double
    let uvi: Double
    let wind_speed: Double
    let wind_deg: Double
    let dew_point: Double
    let weather: [Weather]
}

struct Weather: Decodable{
    let id: Int
}

struct Hourly: Decodable, Identifiable {
    var id: Int {
        return dt
    }
    let dt: Int
    let temp: Double
    let humidity: Double
    let wind_speed: Double
    let wind_deg: Double
    let pop: Double
    let weather: [Weather]
}

struct Daily: Decodable, Identifiable {
    var id: Int {
        return dt
    }
    let dt: Int
    let temp: Temp
    let wind_speed: Double
    let wind_deg: Double
    let pop: Double
    let weather: [Weather]
    let uvi: Double
}

struct Temp: Decodable {
    let min: Double
    let max: Double
}

struct Alert: Decodable, Identifiable {
    let id = UUID()
    let sender_name: String
    let event: String
    let start: Int
    let end: Int
    let description: String
}

struct LocationResponse: Decodable {
    let name: String
}

struct AQIresponse: Decodable {
    let list: [AQIlist]
}

struct AQIlist: Decodable {
    let main: AQImain
}

struct AQImain: Decodable {
    let aqi: Int
}



