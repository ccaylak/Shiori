import Foundation

enum AnimeMode: String, CaseIterable {
    case episodes, time
    
    var displayName: String {
        switch self {
        case .episodes: return String(localized: "In episodes", comment: "Anime mode")
        case .time: return String(localized: "In time", comment: "Anime mode")
        }
    }
}
