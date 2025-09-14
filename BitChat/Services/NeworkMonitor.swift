import Network
import Combine

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = false
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
