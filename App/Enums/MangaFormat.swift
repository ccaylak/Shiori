import Foundation

enum MangaFormat: String, CaseIterable {
    case both, volume, chapter
    
    var displayName: String {
        switch self {
        case .both: return String(localized: "Chapters & Volumes", comment: "Manga mode")
        case .volume: return String(localized: "Volume", comment: "Manga mode")
        case .chapter: return String(localized: "Chapter", comment: "Manga mode")
        }
    }
}
