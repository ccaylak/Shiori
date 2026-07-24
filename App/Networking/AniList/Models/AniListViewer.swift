import Foundation

struct AniListViewerResponse: Decodable {
    let data: AniListViewerData
}

struct AniListViewerData: Decodable {
    let viewer: AniListViewer
}

struct AniListViewer: Decodable {
    let id: Int
    let name: String
    let avatar: AniListViewerAvatar?
    let siteUrl: String?
    let createdAt: Int?
}

struct AniListViewerAvatar: Decodable {
    let large: String?
}
