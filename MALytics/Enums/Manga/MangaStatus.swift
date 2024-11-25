import Foundation

enum MangaStatus: String, CaseIterable {
    case finished = "finished"
    case currentlyPublishing = "currently_publishing"
    case notYetPublished = "not_yet_published"
    case onHiatus = "on_hiatus"
    case discontinued = "discontinued"
    case unknown = "unknown"
    
    var displayName: String {
        switch self {
        case .finished: 
            return "Finished"
        case .currentlyPublishing: 
            return "Currently Publishing"
        case .notYetPublished: 
            return "Not Yet Published"
        case .onHiatus: 
            return "On Hiatus"
        case .discontinued: 
            return "Discontinued"
        case .unknown: 
            return "Unknown"
        }
    }
}
