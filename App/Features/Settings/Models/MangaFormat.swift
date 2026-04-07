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
    
    var description: String {
            switch self {
            case .both:
                return "Shows both chapter and volume progress. Useful if you track everything."
            case .chapter:
                return "Focuses only on chapters. Best for detailed reading progress."
            case .volume:
                return "Focuses on volumes. Cleaner if you mainly track volumes."
            }
        }
}
