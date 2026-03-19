import Foundation

struct JikanMedia: Decodable {
    
    private(set) var data: [JikanMediaData]
    private(set) var pagination: JikanPagination?
    
    mutating func append(_ newData: [JikanMediaData]) {
        data.append(contentsOf: newData)
    }
}

struct JikanMediaData: Decodable, Identifiable {
    
    private(set) var malId: Int
    private(set) var titles: [JikanTitle]
    private(set) var images: JikanImages
    private(set) var type: String?
    private(set) var status: String?
    private(set) var score: Double?
    
    var id: Int {malId}
}
