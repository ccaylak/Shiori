import Foundation

struct AnimeNode: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case node
        case relationType = "relation_type_formatted"
    }
    
    let node: Anime
    let relationType: String?
    
    init(node: Anime, relationType: String?) {
        self.node = node
        self.relationType = relationType
    }
}
