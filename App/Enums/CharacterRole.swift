import Foundation

enum CharacterRole: String, CaseIterable {
    case all, main, supporting
    
    var displayName: String {
        switch self {
        case .all:
            return String(localized: "All")
        case .main:
            return String(localized: "Main")
        case .supporting:
            return String(localized: "Supporting")
        }
    }
    
    var icon: String {
        switch self {
        case .all:
            return "person.3.fill"
        case .main:
            return "person.2.fill"
        case .supporting:
            return "person.fill"
        }
    }
}
