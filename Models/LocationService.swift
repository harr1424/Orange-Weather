
import Foundation
import Combine
import MapKit

struct LocationResult : Hashable {
    var city: String
    var country: String
}

class LocationService: NSObject, ObservableObject {

    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [LocationResult] = []

    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        self.searchCompleter.region = MKCoordinateRegion(.world)
        self.searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        super.init()
        self.searchCompleter.delegate = self

        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
}

extension LocationService: MKLocalSearchCompleterDelegate {
    func buildCityTypeA(_ title: [String],_ subtitle: [String])  -> LocationResult {
        
        var newLocation = LocationResult(city: "", country: "")
        
        if title.count > 1 && subtitle.count >= 1 {
            
            newLocation.city = title.joined(separator: ", ")
            newLocation.country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
        }
        
        return newLocation
    }

    func buildCityTypeB(_ title: [String],_ subtitle: [String]) -> LocationResult {

        var newLocation = LocationResult(city: "", country: "")

        if title.count >= 1 && subtitle.count == 1 {

            newLocation.city = title.joined(separator: ", ")
            newLocation.country = subtitle.last!
        }

        return newLocation
    }
    
    func getCityList(results: [MKLocalSearchCompletion]) -> [LocationResult] {
        
        var searchResults: [LocationResult] = []
        
        for result in results {
                        
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            
            var candidateLocation: LocationResult
            
            candidateLocation = buildCityTypeA(titleComponents, subtitleComponents)
                
                if candidateLocation.city != "" && candidateLocation.country != "" {
                    searchResults.append(candidateLocation)
                }
            
            
            candidateLocation = buildCityTypeB(titleComponents, subtitleComponents)

                if candidateLocation.city != "" && candidateLocation.country != ""{

                    searchResults.append(candidateLocation)
                }
            }
        
        return searchResults
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = getCityList(results: completer.results)
        self.searchResults = self.searchResults.unique()
        self.status = completer.results.isEmpty ? .noResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
    
}
