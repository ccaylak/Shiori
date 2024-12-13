import Foundation

enum AnimeProgressStatus: String, CaseIterable {
    case completed = "completed"
    case watching = "watching"
    case onHold = "on_hold"
    case dropped = "dropped"
    case planToWatch = "plan_to_watch"
    
    
    var displayName: String {
        switch self {
        case .watching: return "Watching"
        case .completed: return "Completed"
        case .onHold: return "On Hold"
        case .dropped: return "Dropped"
        case .planToWatch: return "Plan To Watch"
        }
    }
}
