import Foundation

enum AccentColor: String, CaseIterable {
    case blue, red, orange, pink, purple
    
    var displayName: String {
        switch self {
        case .blue: return String(localized: "Blue")
        case .red: return String(localized: "Red")
        case .orange: return String(localized: "Orange")
        case .pink: return String(localized: "Pink")
        case .purple: return String(localized: "Purple")
        }
    }
}
