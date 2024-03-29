import Foundation
import WeatherKit

// Format date according to format string 
extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

// Returns abbreviated wind directions
extension Wind {
    func getAbbreviatedDirections() -> String {
        
        switch self.compassDirection.description {
        case "North":
            return "N"
        case "East":
            return "E"
        case "South":
            return "S"
        case "West":
            return "W"
        case "Northeast":
            return "NE"
        case "Southeast":
            return "SE"
        case "Southwest":
            return "SW"
        case "Northwest":
            return "NW"
        case "North Northeast":
            return "NNE"
        case "East Northeast":
            return "ENE"
        case "East Southeast":
            return "ESE"
        case "South Southeast":
            return "SSE"
        case "South Southwest":
            return "SSW"
        case "West Southwest":
            return "WSW"
        case "West Northwest":
            return "WNW"
        case "North Northwest":
            return "NNW"
        default:
            return ""
        }
    }
}

// Remove forecast elements corresponding to the past
extension Forecast where Element == HourWeather{
    func futureElements() -> [HourWeather] {
        var futures = [HourWeather]()
        
        for each in self.forecast {
            if each.date > Date() {
                futures.append(each)
            }
        }
        
        return futures
    }
}

// Create a set from an array while preserving order
extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

// Allows all Codable Arrays to be saved using AppStorage
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension DayWeather {
    func getPrecipitationType() -> String {
        if self.precipitation.description == "" {
            if self.lowTemperature.value < 4 {
                return "snow"
            }
            else {
                return "rain"
            }
        }
        else {
            return self.precipitation.description
        }
    }
}

extension HourWeather {
    func getPrecipitationType() -> String {
        if self.precipitation.description == "" {
            if self.temperature.value < 4 {
                return "snow"
            }
            else {
                return "rain"
            }
        }
        else {
            return self.precipitation.description
        }
    }
}
