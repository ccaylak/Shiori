import Foundation

enum FormatType {
    case anime(Anime)
    case manga(Manga)
    
    enum Anime: String, CaseIterable {
        case unknown, tv, ova, movie, special, ona, music, cm, pv
        case tvSpecial = "tv_special"
        
        var displayName: String {
            switch self {
            case .unknown: return String(localized: "Unknown anime type", comment: "Anime type")
            case .tv: return String(localized: "TV", comment: "Anime type")
            case .ova: return String(localized: "OVA", comment: "Anime type")
            case .movie: return String(localized: "Movie", comment: "Anime type")
            case .tvSpecial: return String(localized: "TV Special", comment: "Anime type")
            case .special: return String(localized: "Special", comment: "Anime type")
            case .ona: return String(localized: "ONA", comment: "Anime type")
            case .music: return String(localized: "Music", comment: "Anime type")
            case .cm: return String(localized: "CM", comment: "Anime type")
            case .pv: return String(localized: "PV", comment: "Anime type")
            }
        }
    }
    
    enum Manga: String, CaseIterable {
        case unknown, manga, novel, doujinshi, manhwa, manhua, oel
        case lightNovel = "light_novel"
        case oneShot = "one_shot"
        
        var displayName: String {
            switch self {
            case .unknown: return String(localized: "Unknown manga type", comment: "Manga type")
            case .manga: return String(localized: "Manga", comment: "Manga type")
            case .novel: return String(localized: "Novel", comment: "Manga type")
            case .oneShot: return String(localized: "One-Shot", comment: "Manga type")
            case .doujinshi: return String(localized: "Doujinshi", comment: "Manga type")
            case .manhwa: return String(localized: "Manhwa", comment: "Manga type")
            case .manhua: return String(localized: "Manhua", comment: "Manga type")
            case .oel: return String(localized: "OEL", comment: "Manga type")
            case .lightNovel: return String(localized: "Light Novel", comment: "Manga type")
            }
        }
    }
    
    var displayName: String {
        switch self {
        case .anime(let type): return type.displayName
        case .manga(let type): return type.displayName
        }
    }
}
