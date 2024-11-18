import Foundation

struct MangaResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "data"
    }
    
    let results: [MangaNode]
    
    init(results: [MangaNode]) {
        self.results = results
    }
}
