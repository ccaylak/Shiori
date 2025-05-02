import Foundation

enum SortType {
    case anime(Anime)
    case manga(Manga)
    case unknown
    
    enum Anime: String, CaseIterable {
        case all, airing, upcoming, tv, ova, movie, special, bypopularity, favorite
        
        var displayName: String {
            switch self {
            case .all: return String(localized: "Top Anime Series", comment: "Sort by")
            case .airing: return String(localized: "Top Airing Anime", comment: "Sort by")
            case .upcoming: return String(localized: "Top Upcoming Anime", comment: "Sort by")
            case .tv: return String(localized: "Top Anime TV Series", comment: "Sort by")
            case .ova: return String(localized: "Top Anime OVA Series", comment: "Sort by")
            case .movie: return String(localized: "Top Anime Movies", comment: "Sort by")
            case .special: return String(localized: "Top Anime Specials", comment: "Sort by")
            case .bypopularity: return String(localized: "Top Anime by Popularity", comment: "Sort by")
            case .favorite: return String(localized: "Top Favorited Anime", comment: "Sort by")
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
    
    enum Manga: String, CaseIterable {
        case all, manga, novels, oneshots, doujin, manhwa, manhua, bypopularity, favorite
        
        var displayName: String {
            switch self {
            case .all: return String(localized: "All", comment: "Sort by")
            case .manga: return String(localized: "Top Manga", comment: "Sort by")
            case .novels: return String(localized: "Top Novels", comment: "Sort by")
            case .oneshots: return String(localized: "Top One-shots", comment: "Sort by")
            case .doujin: return String(localized: "Top Doujinshi", comment: "Sort by")
            case .manhwa: return String(localized: "Top Manhwa", comment: "Sort by")
            case .manhua: return String(localized: "Top Manhua", comment: "Sort by")
            case .bypopularity: return String(localized: "Most Popular", comment: "Sort by")
            case .favorite: return String(localized: "Most Favorited", comment: "Sort by")
            }
        }
    }
    
    var displayName: String {
        switch self {
        case .anime(let sortby): return sortby.displayName
        case .manga(let sortby): return sortby.displayName
        case .unknown: return String("Unknown sort type")
        }
    }
}
