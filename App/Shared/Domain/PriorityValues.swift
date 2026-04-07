import Foundation

enum PriorityValues: Int, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    
    var displayName: String {
        switch self {
        case .low: return String(localized: "Low", comment: "Priority")
        case .medium: return String(localized: "Medium", comment: "Priority")
        case .high: return String(localized: "High", comment: "Priority")
        }
    }
}
