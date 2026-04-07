import Foundation

enum MediaSort: Equatable {
    case anime(AnimeSort)
    case manga(MangaSort)
    
    enum AnimeSort: String, CaseIterable {
        case listScore = "list_score"
        case listUpdatedAt = "list_updated_at"
        case animeTitle = "anime_title"
        case animeStartDate = "anime_start_date"
        case episodes, totalDuration
        
        var displayName: String {
            switch self {
            case .listScore: return String(localized: "Score")
            case .listUpdatedAt: return String(localized: "Last Updated")
            case .animeTitle: return String(localized: "Title")
            case .animeStartDate: return String(localized: "Airing Date")
            case .episodes: return String(localized: "Episodes")
            case .totalDuration: return String(localized: "Total Duration")
            }
        }
        
        var icon: String {
            switch self {
            case .listScore: return "star.fill"
            case .listUpdatedAt: return "arrow.trianglehead.2.clockwise.rotate.90"
            case .animeTitle: return "textformat.characters"
            case .animeStartDate: return "calendar"
            case .episodes: return "play.rectangle.on.rectangle.fill"
            case .totalDuration: return "clock"
            }
        }
    }
    
    enum MangaSort: String, CaseIterable {
        
        case listScore = "list_score"
        case listUpdatedAt = "list_updated_at"
        case mangaTitle = "manga_title"
        case mangaStartDate = "manga_start_date"
        case chapter, volume, both
        
        var displayName: String {
            switch self {
            case .listScore: return String(localized: "Score")
            case .listUpdatedAt: return String(localized: "Last Updated")
            case .mangaTitle: return String(localized: "Title")
            case .mangaStartDate: return String(localized: "Serialization Date")
            case .chapter: return String(localized: "Chapter")
            case .volume: return String(localized: "Volume")
            case .both: return String(localized: "Both")
            }
        }
        
        var icon: String {
            switch self {
            case .listScore: return "star.fill"
            case .listUpdatedAt: return "clock.arrow.trianglehead.2.counterclockwise.rotate.90"
            case .mangaTitle: return "textformat.characters"
            case .mangaStartDate: return "calendar"
            case .chapter: return "book.pages.fill"
            case .volume: return "character.book.closed.fill.ja"
            case .both: return "books.vertical.fill"
            }
        }
    }

}
