import Foundation

struct Media: Decodable, Hashable, Identifiable {
    
    var id: Int { node.id }
    private(set) var node: MediaNode
    private(set) var relationType: String?
    private(set) var relationTypeFormatted: String?
    private(set) var listStatus: MyListStatus?
}

extension Media {
    var getRelationType: Related {
        Related(rawValue: relationType ?? "") ?? .unknown
    }
}
