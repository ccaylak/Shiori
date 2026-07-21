import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    
    enum Status: Equatable {
        case checking
        case connected
        case disconnected
    }
    
    enum Quality: Equatable {
        case unknown
        case good
        case moderate
        case weak
    }
    
    private(set) var status: Status = .checking
    private(set) var quality: Quality = .unknown
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(
        label: "com.shiori.network-monitor"
    )
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let newStatus: Status = path.status == .satisfied
                ? .connected
                : .disconnected
            
            let newQuality: Quality
            
            if #available(iOS 26.0, *) {
                switch path.linkQuality {
                case .good:
                    newQuality = .good

                case .moderate:
                    newQuality = .moderate

                case .minimal:
                    newQuality = .weak

                case .unknown:
                    newQuality = .unknown

                @unknown default:
                    newQuality = .unknown
                }
            } else {
                newQuality = .unknown
            }
            
            Task { @MainActor [weak self] in
                self?.status = newStatus
                self?.quality = newQuality
            }
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}

