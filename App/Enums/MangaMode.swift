import Foundation

enum MangaMode: String, CaseIterable {
    case all, volume, chapter
    
    var displayName: String {
        switch self {
        case .all: return String(localized: "Both", comment: "Manga mode")
        case .volume: return String(localized: "In volumes", comment: "Manga mode")
        case .chapter: return String(localized: "In chapters", comment: "Manga mode")
        }
    }
}
