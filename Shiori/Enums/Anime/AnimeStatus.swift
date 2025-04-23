import Foundation

enum AnimeStatus: String {
    case unknown
    case finishedAiring = "finished_airing"
    case currentlyAiring = "currently_airing"
    case notYetAired = "not_yet_aired"
    
    var displayName: String {
        switch self {
        case .finishedAiring: return String(localized: "Finished")
        case .currentlyAiring: return String(localized: "Airing")
        case .notYetAired: return String(localized: "Airing soon")
        case .unknown: return String(localized: "Unknown")
        }
    }
}

