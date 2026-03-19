import Foundation

struct JikanGenre: Decodable {
    
    private(set) var data: [JikanGenreData]
}

struct JikanGenreData: Decodable {
    
    private(set) var malId: Int
    private(set) var name: String
    private(set) var count: Int
}
