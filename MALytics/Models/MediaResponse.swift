import Foundation

struct MediaResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "data"
        case page = "paging"
    }
    
    var results: [MediaNode]
    var page: Paging?
    
    init(results: [MediaNode], page: Paging?) {
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
