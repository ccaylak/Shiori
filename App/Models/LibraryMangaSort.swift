import Foundation

enum LibraryMangaSort: String, CaseIterable {
    
    case score = "list_score"
    case lastUpdated = "list_updated_at"
    case title = "manga_title"
    case startDate = "manga_start_date"
    
    var displayName: String {
        switch self {
        case .score: return String(localized: "Score")
        case .lastUpdated: return String(localized: "Last updated")
        case .title: return String(localized: "Title")
        case .startDate: return String(localized: "Serialization date")
        }
    }
    
    var icon: String {
        switch self {
        case .score: return "star.fill"
        case .lastUpdated: return "clock.arrow.trianglehead.2.counterclockwise.rotate.90"
        case .title: return "textformat.characters"
        case .startDate: return "calendar"
        }
    }
}

