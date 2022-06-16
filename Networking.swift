//
//  LocationManager.swift
//  Orange Weather
//
//  Created by user on 6/11/22.
//

import Foundation
import CoreLocation
import SwiftUI

class Networking: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var weatherResponse: WeatherResponse?
    @Published var locationString: LocationResponse?
    @Published var currAQI: AQIresponse?

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        getMainWeather(self.lastLocation?.coordinate.latitude ?? 0, self.lastLocation?.coordinate.longitude ?? 0)
        getLocationString(self.lastLocation?.coordinate.latitude ?? 0, self.lastLocation?.coordinate.longitude ?? 0)
        getAQI(self.lastLocation?.coordinate.latitude ?? 0, self.lastLocation?.coordinate.longitude ?? 0)
        locationManager.stopUpdatingLocation()
    }
    
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
