import Foundation

struct AnimeResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "data"
    }
    
    let results: [AnimeNode]
    
    init(results: [AnimeNode]) {
        self.results = results
    }
}
