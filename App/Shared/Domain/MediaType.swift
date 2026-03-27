import Foundation

enum SeriesType: String {
    case manga, anime
    
    var displayName: String {
        switch self {
        case .anime: return String(localized: "Anime")
        case .manga: return String(localized: "Manga")
        }
    }
    
    var icon: String {
        switch self {
        case .anime: return "tv"
        case .manga: return "character.book.closed.ja"
        }
    }
}
