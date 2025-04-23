import Foundation

enum AnimeProgressStatus: String, CaseIterable {
    case all, completed, watching, dropped
    case onHold = "on_hold"
    case planToWatch = "plan_to_watch"
    
    var displayName: String {
        switch self {
        case .all: return String(localized: "All")
        case .watching: return String(localized: "Watching")
        case .completed: return String(localized: "Completed")
        case .onHold: return String(localized: "On Hold")
        case .dropped: return String(localized: "Dropped")
        case .planToWatch: return String(localized: "Plan To Watch")
        }
    }
}
