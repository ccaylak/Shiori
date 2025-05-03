import Foundation

extension AuthorInfos {
    var getAuthor: String {
        if let firstName = author?.firstName, let lastName = author?.lastName {
            return "\(firstName) \(lastName), (\(role))"
        } else if let firstName = author?.firstName {
            return "\(firstName) (\(role))"
        } else if let lastName = author?.lastName {
            return "\(lastName) (\(role))"
        } else {
            return "Unknown Author"
        }
    }
}
