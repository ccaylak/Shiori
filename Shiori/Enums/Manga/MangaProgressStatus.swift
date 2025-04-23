import Foundation

enum MangaProgressStatus: String, CaseIterable {
    case all, completed, reading, dropped
    case onHold = "on_hold"
    case planToRead = "plan_to_read"
        
    var displayName: String {
        switch self {
        case .reading: return String(localized: "Reading")
        case .completed: return String(localized: "Completed")
        case .onHold: return String(localized: "On Hold")
        case .dropped: return String(localized: "Dropped")
        case .planToRead: return String(localized: "Plan To Read")
        case .all: return String(localized: "All")
        }
    }
}
