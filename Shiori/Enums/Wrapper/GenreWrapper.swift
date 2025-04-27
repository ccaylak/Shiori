import Foundation

enum GenreWrapper: Equatable, Hashable {
    case manga(MangaGenre)
    case anime(AnimeGenre)
    case unknown
    
    var displayName: String {
        switch self {
        case .anime(let animeGenre): return animeGenre.displayName
        case .manga(let mangaGenre): return mangaGenre.displayName
        case .unknown: return String(localized: "Unknown genre")
        }
    }
}
