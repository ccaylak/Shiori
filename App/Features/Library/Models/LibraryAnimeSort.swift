import Foundation

enum LibraryAnimeSort: String, CaseIterable {
    
    case score = "list_score"
    case lastUpdated = "list_updated_at"
    case title = "anime_title"
    case startDate = "anime_start_date"
    //case episode, totalDuration
    
    var displayName: String {
        switch self {
        case .score: return String(localized: "Score")
        case .lastUpdated: return String(localized: "Last updated")
        case .title: return String(localized: "Title")
        case .startDate: return String(localized: "Airing date")
        //case .episode: return String(localized: "Episodes")
        //case .totalDuration: return String(localized: "Total duration")
        }
    }
    
    var icon: String {
        switch self {
        case .score: return "star"
        case .lastUpdated: return "arrow.trianglehead.2.clockwise.rotate.90"
        case .title: return "textformat.characters"
        case .startDate: return "calendar"
        //case .episode: return "rectangle.3.offgrid.in.out"
        //case .totalDuration: return "clock"
        }
    }
}
