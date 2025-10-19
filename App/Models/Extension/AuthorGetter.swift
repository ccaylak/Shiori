import Foundation

extension AuthorInfos {
    var getAuthor: String {
        if let firstName = author?.firstName, !firstName.isEmpty,
           let lastName = author?.lastName, !lastName.isEmpty {
            return "\(firstName) \(lastName) (\(role))"
        } else if let firstName = author?.firstName, !firstName.isEmpty {
            return "\(firstName) (\(role))"
        } else if let lastName = author?.lastName, !lastName.isEmpty {
            return "\(lastName) (\(role))"
        } else {
            return "Unknown Author"
        }

    }
}
