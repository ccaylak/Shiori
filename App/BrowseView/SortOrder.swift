import Foundation

enum SortOrder: String, CaseIterable {
    case def = ""
    case asc, desc
    
    var displayName: String {
        switch self {
        case .def: String(localized: "Default")
        case .asc: String(localized: "Ascending")
        case .desc: String(localized: "Descending")
        }
    }
    
    var icon: String {
        switch self {
        case .def: return "arrow.up.arrow.down"
        case .asc: return "arrow.up"
        case .desc: return "arrow.down"
        }
    }
}
