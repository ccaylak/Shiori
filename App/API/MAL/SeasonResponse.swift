import Foundation

struct SeasonResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: [MediaNode]
}
