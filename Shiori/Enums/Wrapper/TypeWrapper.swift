import Foundation

enum TypeWrapper: Equatable {
    case anime(AnimeType)
    case manga(MangaType)

    var displayName: String {
        switch self {
        case .anime(let anime): return anime.displayName
        case .manga(let manga): return manga.displayName
        }
    }
}
