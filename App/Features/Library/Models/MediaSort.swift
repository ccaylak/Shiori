import Foundation

enum MediaSort: Equatable {
    case anime(AnimeSort)
    case manga(MangaSort)
    
    enum AnimeSort: String, CaseIterable {
        case listScore, listUpdatedAt, animeTitle, animeStartDate
        
        var displayName: String {
            switch self {
            case .listScore: return String(localized: "Score")
            case .listUpdatedAt: return String(localized: "Last Updated")
            case .animeTitle: return String(localized: "Title")
            case .animeStartDate: return String(localized: "Airing Date")
            }
        }
        
        var apiValue: String? {
            switch self {
            case .listScore:
                return "list_score"
            case .listUpdatedAt:
                return "list_updated_at"
            case .animeTitle:
                return "anime_title"
            case .animeStartDate:
                return "anime_start_date"
            }
        }
        
        var apiDirection: SortDirection {
                switch self {
                case .animeTitle:
                    return .ascending
                case .listScore, .listUpdatedAt, .animeStartDate:
                    return .descending
                }
            }
        
        var icon: String {
            switch self {
            case .listScore: return "star.fill"
            case .listUpdatedAt: return "arrow.trianglehead.2.clockwise.rotate.90"
            case .animeTitle: return "textformat.characters"
            case .animeStartDate: return "calendar"
            }
        }
    }
    
    enum MangaSort: String, CaseIterable {
        
        case listScore, listUpdatedAt, mangaTitle, mangaStartDate
        
        var displayName: String {
            switch self {
            case .listScore: return String(localized: "Score")
            case .listUpdatedAt: return String(localized: "Last Updated")
            case .mangaTitle: return String(localized: "Title")
            case .mangaStartDate: return String(localized: "Serialization Date")
            }
        }
        
        var apiDirection: SortDirection {
                switch self {
                case .mangaTitle:
                    return .ascending
                case .listScore, .listUpdatedAt, .mangaStartDate:
                    return .descending
                }
            }
        
        var apiValue: String? {
            switch self {
            case .mangaTitle:
                return "manga_title"
            case .listScore:
                return "list_score"
            case .listUpdatedAt:
                return "list_updated_at"
            case .mangaStartDate:
                return "manga_start_date"
            }
        }
        
        var icon: String {
            switch self {
            case .listScore: return "star.fill"
            case .listUpdatedAt: return "clock.arrow.trianglehead.2.counterclockwise.rotate.90"
            case .mangaTitle: return "textformat.characters"
            case .mangaStartDate: return "calendar"
            }
        }
    }

}
