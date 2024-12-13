import Foundation

enum MangaSortType: String, CaseIterable {
    case all = "all"
    case manga = "manga"
    case novels = "novels"
    case oneshots = "oneshots"
    case doujin = "doujin"
    case manhwa = "manhwa"
    case manhua = "manhua"
    case bypopularity = "bypopularity"
    case favorite = "favorite"
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .manga: return "Top Manga"
        case .novels: return "Top Novels"
        case .oneshots: return "Top One-shots"
        case .doujin: return "Top Doujinshi"
        case .manhwa: return "Top Manhwa"
        case .manhua: return "Top Manhua"
        case .bypopularity: return "Most Popular"
        case .favorite: return "Most Favorited"
        }
    }
}
