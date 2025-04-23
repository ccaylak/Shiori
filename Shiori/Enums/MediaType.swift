import Foundation

enum MediaType: String {
    case manga, anime
    
    var displayName: String {
        switch self {
        case .anime: return String(localized: "Anime")
        case .manga: return String(localized: "Manga")
        }
    }
}
