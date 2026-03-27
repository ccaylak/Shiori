import Foundation

enum AnimeFormat: String, CaseIterable {
    case episodesWithDuration, episode
    
    var displayName: String {
        switch self {
        case .episode: return String(localized: "Episodes", comment: "Anime mode")
        case .episodesWithDuration: return String(localized: "Episodes with duration", comment: "Anime mode")
        }
    }
}
