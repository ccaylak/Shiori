import Foundation

struct JikanAnimeStudio: Decodable {
    enum CodingKeys: String, CodingKey {
        case data, pagination
    }
    
    var data: [JikanAnimeStudioData]
    let pagination: JikanPagination?
}

struct JikanAnimeStudioResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: JikanAnimeStudioData
}

struct JikanAnimeStudioData: Decodable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case url, titles, images, favorites, established, count, about
    }
    
    let malId: Int
    let url: String
    let favorites: Int
    let titles: [JikanTitleData]
    let images: JikanImageData
    let count: Int
    let established: String?
    let about: String?
}

struct JikanTitleData: Decodable {
    enum CodingKeys: String, CodingKey {
        case type, title
    }
    
    let type: String
    let title: String
}

struct JikanImageData: Decodable {
    enum CodingKeys: String, CodingKey {
        case jpg
    }
    
    let jpg: JikanImageUrl
}

struct JikanImageUrl: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
    
    let imageUrl: String
}

struct JikanPagination: Decodable {
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case items
    }
    
    let currentPage: Int
    let lastVisiblePage: Int
    let hasNextPage: Bool
    let items: JikanPaginationData
}

struct JikanPaginationData: Decodable {
    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case count, total
    }
    
    let perPage: Int
    let count: Int
    let total: Int
}
