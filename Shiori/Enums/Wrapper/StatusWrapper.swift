import Foundation

enum StatusWrapper: Equatable {
    case anime(AnimeStatus)
    case manga(MangaStatus)
    case unknown
    
    var displayName: String {
        switch self {
        case .anime(let status): return status.displayName
        case .manga(let status): return status.displayName
        case .unknown: return "Unknown"
        }
    }
}
