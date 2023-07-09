import Foundation
import Network

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
