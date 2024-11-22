import Foundation

struct AnimeResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "data"
        case page = "paging"
    }
    
    var results: [AnimeNode]
    var page: Paging?
    
    init(results: [AnimeNode], page: Paging?) {
        self.results = results
        self.page = page
    }
    
    struct Paging: Decodable {
        let next: String
        
        init(next: String) {
            self.next = next
        }
    }
}
