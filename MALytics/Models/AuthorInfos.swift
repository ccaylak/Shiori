import Foundation

struct AuthorInfos: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case role
        case author = "node"
    }
    
    let author: Author?
    let role: String
    
    init(author: Author? = nil, role: String) {
        self.author = author
        self.role = role
    }
    
    struct Author: Decodable, Hashable {
        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
        }
        
        let id: Int
        let firstName: String?
        let lastName: String?
        
        init(id: Int, firstName: String? = nil, lastName: String? = nil) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
        }
    }
}
