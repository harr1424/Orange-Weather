import Foundation
import Network

/* This class is responsible for determining the connectivity
 status of a user's device. */
class NetworkStatus: ObservableObject {
    
    @Published var isConnected = false

    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}
