import Foundation
import WeatherKit

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

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

// Create a set from an array while preserving order
public extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
