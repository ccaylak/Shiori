import Foundation

struct Author: Decodable, Hashable {
    private(set) var node: AuthorNode
    private(set) var role: String
}

struct AuthorNode: Decodable, Hashable {
    private(set) var id: Int
    private(set) var firstName: String?
    private(set) var lastName: String?
}

extension AuthorNode {
    var fullName: String {
        if let firstName, !firstName.isEmpty,
           let lastName, !lastName.isEmpty {
            return "\(firstName) \(lastName)"
        } else if let firstName, !firstName.isEmpty {
            return firstName
        } else if let lastName, !lastName.isEmpty {
            return lastName
        } else {
            return ""
        }
    }
}
