import Foundation

enum MangaType: String, CaseIterable {
    case unknown = "unknown"
    case manga = "manga"
    case novel = "novel"
    case light_novel = "light_novel"
    case one_shot = "one_shot"
    case doujinshi = "doujinshi"
    case manhwa = "manhwa"
    case manhua = "manhua"
    case oel = "oel"
    
    var displayName: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .manga:
            return "Manga"
        case .novel:
            return "Novel"
        case .one_shot:
            return "One-Shot"
        case .doujinshi:
            return "Doujinshi"
        case .manhwa:
            return "Manhwa"
        case .manhua:
            return "Manhua"
        case .oel:
            return "OEL"
        case .light_novel:
            return "Light Novel"
        }
    }
}
