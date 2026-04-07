import Foundation

enum AnimeFormat: String, CaseIterable {
    case episode, episodesWithDuration
    
    var displayName: String {
        switch self {
            case .episode: return String(localized: "Episodes", comment: "Anime mode")
            case .episodesWithDuration: return String(localized: "Episodes with duration", comment: "Anime mode")
        }
    }
    
    var description: String {
        switch self {
            case .episode: return String(localized: "Tracks your progress by episodes.")
            case .episodesWithDuration: return String(localized: "Tracks episodes and shows the total remaining watch time.")
        }
    }
}
