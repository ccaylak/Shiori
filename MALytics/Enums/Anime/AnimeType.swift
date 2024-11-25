import Foundation

enum AnimeType: String {
    case unknown = "unknown"
    case tv = "tv"
    case ova = "ova"
    case movie = "movie"
    case tvSpecial = "tv_special"
    case special = "special"
    case ona = "ona"
    case music = "music"
    case cm = "cm"
    case pv = "pv"
    
    var displayName: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .tv:
            return "TV"
        case .ova:
            return "OVA"
        case .movie:
            return "Movie"
        case .tvSpecial:
            return "TV Special"
        case .special:
            return "Special"
        case .ona:
            return "ONA"
        case .music:
            return "Music"
        case .cm:
            return "CM"
        case .pv:
            return "PV"
        }
    }
}
