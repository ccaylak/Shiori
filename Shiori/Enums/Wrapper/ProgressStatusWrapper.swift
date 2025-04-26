import Foundation

enum ProgressStatusWrapper: Equatable {
    case manga(MangaProgressStatus)
    case anime(AnimeProgressStatus)
    case unknown
    
    var displayName: String {
        switch self {
        case .anime(let status): return status.displayName
        case .manga(let status): return status.displayName
        case .unknown: return String(localized: "Unknown progress status")
        }
    }
}
