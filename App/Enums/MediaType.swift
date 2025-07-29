import Foundation

enum MediaType: String {
    case manga, anime, unknown
    
    var displayName: String {
        switch self {
        case .anime: return String(localized: "Anime")
        case .manga: return String(localized: "Manga")
        case .unknown: return String(localized: "Unknown")
        }
    }
    
    var icon: String {
        switch self {
        case .anime: return "tv"
        case .manga: return "character.book.closed.ja"
        default: return "questionmark.circle"
        }
    }
}
