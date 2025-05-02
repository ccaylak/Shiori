import Foundation

enum Status: Equatable {
    case anime(Anime)
    case manga(Manga)
    case unknown
    
    enum Anime: String, CaseIterable {
        case finishedAiring = "finished_airing"
        case currentlyAiring = "currently_airing"
        case notYetAired = "not_yet_aired"
        case unknown
        
        var displayName: String {
            switch self {
            case .finishedAiring: return String(localized: "Finished", comment: "Status")
            case .currentlyAiring: return String(localized: "Airing", comment: "Status")
            case .notYetAired: return String(localized: "Airing soon", comment: "Status")
            case .unknown: return String(localized: "Unknown status", comment: "Status")
            }
        }
    }
    
    enum Manga: String, CaseIterable {
        case finished, discontinued, unknown
        case currentlyPublishing = "currently_publishing"
        case notYetPublished = "not_yet_published"
        case onHiatus = "on_hiatus"
        
        var displayName: String {
            switch self {
            case .finished: return String(localized: "Finished", comment: "Status")
            case .currentlyPublishing: return String(localized: "Currently publishing", comment: "Status")
            case .notYetPublished: return String(localized: "Publishing soon", comment: "Status")
            case .onHiatus: return String(localized: "On hiatus", comment: "Status")
            case .discontinued: return String(localized: "Discontinued", comment: "Status")
            case .unknown: return String(localized: "Unknown status", comment: "Status")
            }
        }
    }
    
    var displayName: String {
        switch self {
        case .anime(let status): return status.displayName
        case .manga(let status): return status.displayName
        case .unknown: return String("Unknown status")
        }
    }
}
