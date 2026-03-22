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
}
