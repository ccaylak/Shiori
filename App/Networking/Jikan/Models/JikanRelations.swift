import Foundation

struct JikanRelations: Decodable {
    
    private(set) var data: [Relation]
}

struct Relation: Decodable {
    
    private(set) var relation: String
    private(set) var entry: [RelationEntry]
}

struct RelationEntry: Decodable {
    
    private(set) var malId: Int
    private(set) var type: String
    private(set) var name: String
}
