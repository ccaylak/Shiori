import Foundation

enum AnimeSortType: String, CaseIterable {
    case all, airing, upcoming, tv, ova, movie, special, bypopularity, favorite
    
    var displayName: String {
        switch self {
        case .all: return String(localized: "Top Anime Series")
        case .airing: return String(localized: "Top Airing Anime")
        case .upcoming: return String(localized: "Top Upcoming Anime")
        case .tv: return String(localized: "Top Anime TV Series")
        case .ova: return String(localized: "Top Anime OVA Series")
        case .movie: return String(localized: "Top Anime Movies")
        case .special: return String(localized: "Top Anime Specials")
        case .bypopularity: return String(localized: "Top Anime by Popularity")
        case .favorite: return String(localized: "Top Favorited Anime")
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "star"
        case .airing: return "clock"
        case .upcoming: return "calendar"
        case .tv: return "tv"
        case .ova: return "play.circle"
        case .movie: return "film"
        case .special: return "sparkles"
        case .bypopularity: return "chart.xyaxis.line"
        case .favorite: return "heart"
        }
    }
}
