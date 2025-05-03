import Foundation

enum AccentColor: String, CaseIterable {
    case blue, red, orange, pink, purple
    
    var displayName: String {
        switch self {
        case .blue: return String(localized: "Blue", comment: "Accent color")
        case .red: return String(localized: "Red", comment: "Accent color")
        case .orange: return String(localized: "Orange", comment: "Accent color")
        case .pink: return String(localized: "Pink", comment: "Accent color")
        case .purple: return String(localized: "Purple", comment: "Accent color")
        }
    }
}
