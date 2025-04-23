import Foundation

enum AnimeType: String {
    case unknown, tv, ova, movie, special, ona, music, cm, pv
    case tvSpecial = "tv_special"
    
    var displayName: String {
        switch self {
        case .unknown: return String(localized: "Unknown")
        case .tv: return String(localized: "TV")
        case .ova: return String(localized: "OVA")
        case .movie: return String(localized: "Movie")
        case .tvSpecial: return String(localized: "TV Special")
        case .special: return String(localized: "Special")
        case .ona: return String(localized: "ONA")
        case .music: return String(localized: "Music")
        case .cm: return String(localized: "CM")
        case .pv: return String(localized: "PV")
        }
    }
}
