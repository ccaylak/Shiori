import Foundation

enum SortDirection: String, CaseIterable {
    case ascending, descending
    
    var displayName: String {
        switch self {
        case .ascending: String(localized: "Ascending")
        case .descending: String(localized: "Descending")
        }
    }
    
    var icon: String {
        switch self {
        case .ascending: return "arrow.up"
        case .descending: return "arrow.down"
        }
    }
}
