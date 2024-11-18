import Foundation

struct AuthorInfos: Decodable {
    enum CodingKeys: String, CodingKey {
        case role
        case author = "node"
    }
    
    let author: Author
    let role: String
    
    init(author: Author, role: String) {
        self.author = author
        self.role = role
    }
    
    struct Author: Decodable {
        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
        }
        
        let id: Int
        let firstName: String
        let lastName: String
        
        init(id: Int, firstName: String, lastName: String) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
        }
    }
}
