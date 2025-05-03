import Foundation

extension MediaNode {
    var getRelationType: Related {
        Related(rawValue: relationType ?? "Unbekannt") ?? .unknown
    }
    
    var getListStatus: ListStatus {
        listStatus ?? ListStatus(status: "Unknown", rating: 0, watchedEpisodes: 0, readChapters: 0)
    }
}
