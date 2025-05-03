import Foundation

enum ProgressStatus: Equatable {
    case anime(Anime)
    case manga(Manga)
    case unknown
    
    enum Anime: String, CaseIterable {
        case all, completed, watching, dropped
        case onHold = "on_hold"
        case planToWatch = "plan_to_watch"
        
        var displayName: String {
            switch self {
            case .all: return String(localized: "All", comment: "Progress status")
            case .watching: return String(localized: "Watching", comment: "Progress status")
            case .completed: return String(localized: "Completed", comment: "Progress status")
            case .onHold: return String(localized: "On Hold", comment: "Progress status")
            case .dropped: return String(localized: "Dropped", comment: "Progress status")
            case .planToWatch: return String(localized: "Plan To Watch", comment: "Progress status")
            }
        }
    }
    
    enum Manga: String, CaseIterable {
        case all, completed, reading, dropped
        case onHold = "on_hold"
        case planToRead = "plan_to_read"
        
        var displayName: String {
            switch self {
            case .all: return String(localized: "All")
            case .reading: return String(localized: "Reading")
            case .completed: return String(localized: "Completed")
            case .onHold: return String(localized: "On Hold")
            case .dropped: return String(localized: "Dropped")
            case .planToRead: return String(localized: "Plan To Read")
            }
        }
    }
    
    var displayName: String {
        switch self {
        case .anime(let status): return status.displayName
        case .manga(let status): return status.displayName
        case .unknown: return String("Unknown progress status")
        }
    }
}
