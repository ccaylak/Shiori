import Foundation

struct MediaNode: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case node
        case relationType = "relation_type_formatted"
    }
    
    let node: Media
    let relationType: String?
    
    init(node: Media, relationType: String?) {
        self.node = node
        self.relationType = relationType
    }
}
