import Foundation

enum LibraryAnimeSort: String, CaseIterable {
    
    case score = "list_score"
    case lastUpdated = "list_updated_at"
    case title = "anime_title"
    case startDate = "anime_start_date"
    
    var displayName: String {
        switch self {
            case .score: return "Score"
            case .lastUpdated: return "Last updated"
            case .title: return "Anime title"
            case .startDate: return "Anime start date"
        }
    }
}
