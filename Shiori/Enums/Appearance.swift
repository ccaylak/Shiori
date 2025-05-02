import Foundation

enum Appearance: String, CaseIterable {
    case system, light, dark
    
    var displayName: String {
        switch self {
        case .system: return String(localized: "System", comment: "Appereance")
        case .light: return String(localized: "Light", comment: "Appereance")
        case .dark: return String(localized: "Dark", comment: "Appereance")
        }
    }
}
