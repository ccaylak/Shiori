import Foundation

enum MangaMode: String, CaseIterable {
    case all, volume, chapter
    
    var displayName: String {
        switch self {
        case .all: return String(localized: "Both", comment: "Manga mode")
        case .volume: return String(localized: "Volume", comment: "Manga mode")
        case .chapter: return String(localized: "Chapter", comment: "Manga mode")
        }
    }
}
