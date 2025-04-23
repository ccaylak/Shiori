import Foundation

enum MangaType: String, CaseIterable {
    case unknown, manga, novel, doujinshi, manhwa, manhua, oel
    case light_novel = "light_novel"
    case one_shot = "one_shot"
    
    var displayName: String {
        switch self {
        case .unknown: return String(localized: "Unknown")
        case .manga: return String(localized: "Manga")
        case .novel: return String(localized: "Novel")
        case .one_shot: return String(localized: "One-Shot")
        case .doujinshi: return String(localized: "Doujinshi")
        case .manhwa: return String(localized: "Manhwa")
        case .manhua: return String(localized: "Manhua")
        case .oel: return String(localized: "OEL")
        case .light_novel: return String(localized: "Light Novel")
        }
    }
}
