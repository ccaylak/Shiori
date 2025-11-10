import Foundation

struct JikanAnime: Decodable {
    enum CodingKeys: String, CodingKey {
        case data, pagination
    }
    
    var data: [JikanAnimeData]
    let pagination: JikanPagination?
}

struct JikanAnimeData: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case images, titles, type, status, score
    }
    
    let malId: Int
    let titles: [JikanTitleData]
    let images: JikanImageData
    let type: String?
    let status: String?
    let score: Double?
    let id = UUID()
}
