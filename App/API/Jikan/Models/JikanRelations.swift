import Foundation

struct JikanRelations: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: [Relation]
}

struct Relation: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case relation, entry
    }
    
    let id: String = UUID().uuidString
    let relation: String
    let entry: [RelationEntry]
}

struct RelationEntry: Decodable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case type, name, url
    }
    
    let malId: Int
    let type: String
    let name: String
    let url: String
}
