import Foundation

enum MangaStatus: String, CaseIterable {
    case finished, discontinued, unknown
    case currentlyPublishing = "currently_publishing"
    case notYetPublished = "not_yet_published"
    case onHiatus = "on_hiatus"
    
    var displayName: String {
        switch self {
        case .finished: return String(localized: "Finished")
        case .currentlyPublishing: return String(localized: "Currently Publishing")
        case .notYetPublished: return String(localized: "Publishing soon")
        case .onHiatus: return String(localized: "On Hiatus")
        case .discontinued: return String(localized: "Discontinued")
        case .unknown: return String(localized: "Unknown")
        }
    }
}
