import Foundation

struct MediaResponse: Decodable {
    
    private(set) var data: [Media]
    private(set) var paging: Paging?
    
    mutating func append(_ newData: [Media]) {
        data.append(contentsOf: newData)
    }
    
    mutating func updatePaging(_ paging: Paging?) {
        self.paging = paging
    }
}

struct Paging: Decodable {
    
    private(set) var previous: String?
    private(set) var next: String?
}
