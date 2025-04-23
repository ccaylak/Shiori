import Foundation

enum MangaSortType: String, CaseIterable {
    case all, manga, novels, oneshots, doujin, manhwa, manhua, bypopularity, favorite
    
    var displayName: String {
        switch self {
        case .all: return String(localized: "All")
        case .manga: return String(localized: "Top Manga")
        case .novels: return String(localized: "Top Novels")
        case .oneshots: return String(localized: "Top One-shots")
        case .doujin: return String(localized: "Top Doujinshi")
        case .manhwa: return String(localized: "Top Manhwa")
        case .manhua: return String(localized: "Top Manhua")
        case .bypopularity: return String(localized: "Most Popular")
        case .favorite: return String(localized: "Most Favorited")
        }
    }
}
