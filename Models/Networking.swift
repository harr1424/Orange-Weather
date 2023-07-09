import Foundation
import CoreLocation
import SwiftUI
import WeatherKit

@MainActor class Networking: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var locationString: CLPlacemark?
    
    @Published var locationStatus: CLAuthorizationStatus?
    
    @Published public var lastLocation: CLLocation? {
        didSet {
            Task {
                getLocationString() { placemark in
                    self.locationString = placemark
                }
                locationManager.stopUpdatingLocation()
            }
            Task {
                await getWeather()
            }
        }
    }
    
    private let weatherService = WeatherService()
    
    @Published var currentWeather: CurrentWeather?
    
    @Published var hourlyForecast:Forecast<HourWeather>?
    
    @Published var dailyForecast: Forecast<DayWeather>?
    
    @Published var weatherAlerts: [WeatherAlert]?
    
    @Published var errorUpdatingWeather = false
    
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
    }
    
    // when user taps on current location, set lastLocation to current device location
    public func useCurrentLocation() {
        locationManager.startUpdatingLocation()
        errorUpdatingWeather = false
    }
    
    func getWeather() async {
        do {
            
            let (current, hourly, daily, alerts) = try await weatherService.weather(for: self.lastLocation!, including: .current, .hourly, .daily, .alerts)
            
            currentWeather = current
            hourlyForecast = hourly
            dailyForecast = daily
            weatherAlerts = alerts
            
            print("First available hourly weather forecast: \(hourly.forecast.first?.date.description(with: .autoupdatingCurrent))")
            
        } catch {
            errorUpdatingWeather = true
            print(error.localizedDescription)
        }
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func getLocationString(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(self.lastLocation!,
                                        completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
                print("Updated locatonString to \(String(describing: firstLocation))")
            }
            else {
                // An error occurred during geocoding.
                completionHandler(nil)
                print("locationString could not be updated: \(String(describing: error))")
            }
        })
    }
    
    
}
