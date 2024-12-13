import Foundation

enum AnimeStatus: String {
    case finishedAiring = "finished_airing"
    case currentlyAiring = "currently_airing"
    case notYetAired = "not_yet_aired"
    case unknown = "unknown"
    
    var displayName: String {
        switch self {
        case .finishedAiring:
            return "Finished"
        case .currentlyAiring:
            return "Airing"
        case .notYetAired:
            return "Coming soon"
        case .unknown:
            return "Unknown"
        }
    }
}

