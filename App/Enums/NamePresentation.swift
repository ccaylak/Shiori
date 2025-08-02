import Foundation

enum NamePresentation: String, CaseIterable {
    case firstLast, lastFirst

    var displayName: String {
        switch self {
        case .firstLast:
            return String(localized: "First Name Last Name")
        case .lastFirst:
            return String(localized: "Last Name, First Name")
        }
    }
}
