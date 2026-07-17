enum APIService: String, CaseIterable {
    case mal
    case anilist
    case jikan
    case tenrai

    var displayName: String {
        switch self {
        case .mal:
            "MyAnimeList"
        case .anilist:
            "AniList"
        case .jikan:
            "Jikan"
        case .tenrai:
            "Tenrai"
        }
    }
    
    var website: String {
        switch self {
            case .mal: "https://myanimelist.net"
            case .anilist: "https://anilist.co"
            case .jikan: "https://jikan.moe"
            case .tenrai: "https://tenrai.org"
        }
    }
    
    var apiBaseUrl: String {
        switch self {
            case .mal: "https://api.myanimelist.net/v2"
            case .anilist: "https://graphql.anilist.co/api"
            case .jikan: "https://api.jikan.moe/v4"
            case .tenrai: "https://api.tenrai.org/v1"
        }
    }
}
