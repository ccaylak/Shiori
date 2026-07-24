import Foundation

enum AccountProvider: String, CaseIterable {
    case myAnimeList
    case aniList

    var displayName: String {
        switch self {
        case .myAnimeList:
            "MyAnimeList"

        case .aniList:
            "AniList"
        }
    }
}
