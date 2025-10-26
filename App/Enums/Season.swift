import Foundation

enum Season: String, CaseIterable {
    case winter, spring, summer, fall
    
    var displayName: String {
        switch self {
        case .winter: return String(localized: "Winter")
        case .spring: return String(localized: "Spring")
        case .summer: return String(localized: "Summer")
        case .fall: return String(localized: "Fall")
        }
    }
    
    var icon: String {
        switch self {
        case .winter: return "snowflake"
        case .spring: return "camera.macro"
        case .summer: return "sun.max"
        case .fall: return "leaf"
        }
    }
    
    static var current: Season {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 12, 1, 2: return .winter
        case 3, 4, 5: return .spring
        case 6, 7, 8: return .summer
        case 9, 10, 11: return .fall
        default: return .winter // Fallback
        }
    }
    
}
