import Foundation

enum LibraryMangaSort: String, CaseIterable {
    
    case score = "list_score"
    case lastUpdated = "list_updated_at"
    case title = "manga_title"
    case startDate = "manga_start_date"
    
    var displayName: String {
        switch self {
            case .score: return "Score"
            case .lastUpdated: return "Last updated"
            case .title: return "Manga title"
            case .startDate: return "Manga start date"
        }
    }
}

