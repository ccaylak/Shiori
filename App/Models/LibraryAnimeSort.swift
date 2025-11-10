import Foundation

enum LibraryAnimeSort: String, CaseIterable {
    
    case score = "list_score"
    case lastUpdated = "list_updated_at"
    case title = "anime_title"
    case startDate = "anime_start_date"
    
    var displayName: String {
        switch self {
        case .score: return String(localized: "Score")
        case .lastUpdated: return String(localized: "Last updated")
        case .title: return String(localized: "Title")
        case .startDate: return String(localized: "Airing date")
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
