import Foundation
import CoreLocation
import SwiftUI

/*
 This class is responsible for acquiring device location and using this information
 to request weather information specific to that loction. Three API endpoints are used
 in order to retreive weather information, a location name, and current air quality
 respectively.
 */

class Networking: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var weatherResponse: WeatherResponse?  // contains weather information
    @Published var locationString: LocationResponse?  // contains a string describing current location
    @Published var currAQI: AQIresponse?  // contains current air quality index
    
    @Published var locationStatus: CLAuthorizationStatus?  // describes user assigned location permissions
    @Published var lastLocation: CLLocation?  // contains information about the user's last location
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    /* A computed property to determine the user's current assigned location
     preference*/
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    /* A computed property used to determine how the UI should respond to
     various permission states*/
    var permissions: Bool {
        switch statusString {
        case "notDetermined": return false
        case "authorizedWhenInUse": return true
        case "authorizedAlways": return true
        case "restricted": return false
        case "denied": return false
        default: return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    
    /* This function is automatically called when the device location is updated.
     Once location is updated, all endpoints are contacted in order to get information
     at the updated location*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        getMainWeather(self.lastLocation?.coordinate.latitude ?? 0, self.lastLocation?.coordinate.longitude ?? 0)
        getLocationString(self.lastLocation?.coordinate.latitude ?? 0, self.lastLocation?.coordinate.longitude ?? 0)
        getAQI(self.lastLocation?.coordinate.latitude ?? 0, self.lastLocation?.coordinate.longitude ?? 0)
        locationManager.stopUpdatingLocation()
    }
    
    
    /* Used to obtain all weather related information at a given location*/
    func getMainWeather(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        if let loc = URL(string: "https://api.openweathermap.org/data/2.5/onecall?appid=redacted&exclude=minutely&units=imperial&lat=\(lat)&lon=\(lon)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: loc) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(WeatherResponse.self, from: safeData)
                            DispatchQueue.main.async {
                                self.weatherResponse = results
                            }
                            print("weatherResponse was successfully updated for \(lat) \(lon)")
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    
    /* Used to obtain a string describing the current device location*/
    func getLocationString(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        if let loc = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=redacted&exclude=minutely&units=imperial&lat=\(lat)&lon=\(lon)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: loc) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(LocationResponse.self, from: safeData)
                            DispatchQueue.main.async {
                                self.locationString = results
                            }
                            print("Location was successfully updated for \(lat) \(lon)")
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    
    /* Used to obtain the current Air Quality Index at the current device location*/
    func getAQI(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        if let loc = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?appid=redacted&exclude=minutely&lat=\(lat)&lon=\(lon)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: loc) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(AQIresponse.self, from: safeData)
                            DispatchQueue.main.async {
                                self.currAQI = results
                            }
                            print("AQI was successfully updated for \(lat) \(lon)")
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
}
