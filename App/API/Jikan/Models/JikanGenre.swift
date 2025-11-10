import Foundation

struct JikanGenre: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: [JikanGenreEntry]
}

struct JikanGenreEntry: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case name, count
    }
    
    let malId: Int
    let name: String
    let count: Int
    let id = UUID()
}
