import Foundation

enum MangaProgressStatus: String, CaseIterable {
    case all = "all"
    case completed = "completed"
    case reading = "reading"
    case onHold = "on_hold"
    case dropped = "dropped"
    case planToRead = "plan_to_read"
    
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .reading: return "Reading"
        case .completed: return "Completed"
        case .onHold: return "On Hold"
        case .dropped: return "Dropped"
        case .planToRead: return "Plan To Read"
        }
    }
}
