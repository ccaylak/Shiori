import Foundation

enum NameFormat: String, CaseIterable {
    case firstLast, lastFirst

    var displayName: String {
        switch self {
        case .firstLast:
            return String(localized: "John Doe")
        case .lastFirst:
            return String(localized: "Doe, John")
        }
    }
    
    var description: String {
        switch self {
        case .firstLast:
            return String(localized: "First name followed by last name.")
        case .lastFirst:
            return String(localized: "Last name first, separated by a comma.")
        }
    }
}
