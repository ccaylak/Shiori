import Foundation

enum RankingType: String, CaseIterable {
        case all, airing, upcoming, tv, ova, movie, special, bypopularity, favorite
        
        var displayName: String {
            switch self {
            case .all: return "Top Anime Series"
            case .airing: return "Top Airing Anime"
            case .upcoming: return "Top Upcoming Anime"
            case .tv: return "Top Anime TV Series"
            case .ova: return "Top Anime OVA Series"
            case .movie: return "Top Anime Movies"
            case .special: return "Top Anime Specials"
            case .bypopularity: return "Top Anime by Popularity"
            case .favorite: return "Top Favorited Anime"
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
