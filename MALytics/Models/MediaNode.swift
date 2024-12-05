import Foundation

struct MediaNode: Decodable, Hashable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case node
        case relationType = "relation_type_formatted"
        case listStatus = "list_status"
    }
    
    let id: String = UUID().uuidString
    let node: Media
    let relationType: String?
    let listStatus: ListStatus?
    
    init(node: Media, relationType: String?, listStatus: ListStatus?) {
        self.node = node
        self.relationType = relationType
        self.listStatus = listStatus
    }
}
