import Foundation

enum StudioSortOption: String, CaseIterable {
    case malId = "mal_id"
    case count, favorites, established
    
    var displayName: String {
        switch self {
        case .malId: String(localized: "Id")
        case .count: String(localized: "Anime")
        case .favorites: String(localized: "Favorites")
        case .established: String(localized: "Established")
        }
    }
    
    var icon: String {
        switch self {
        case .malId: return "barcode"
        case .count: return "chart.bar"
        case .favorites: return "heart"
        case .established: return "calendar"
        }
    }
}
