import Foundation

enum Gender: String {
    case male, female
    case nonBinary = "non-binary"
    
    var displayName: String {
        switch self {
        case .male: return String(localized: "Male ♂", comment: "Gender")
        case .female: return String(localized: "Female ♀", comment: "Gender")
        case .nonBinary: return String(localized: "Non-binary ⚧", comment: "Gender")
        }
    }
}
