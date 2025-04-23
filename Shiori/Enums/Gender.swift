import Foundation

enum Gender: String {
    case male, female
    case nonBinary = "non-binary"
    
    var displayName: String {
        switch self {
        case .male: return String(localized: "Male")
        case .female: return String(localized: "Female")
        case .nonBinary: return String(localized: "Non-binary")
        }
    }
}
