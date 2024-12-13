import Foundation

extension ListStatus {
    var getStatus: String {
        status ?? "Unknown"
    }
    
    var getRating: Int {
        rating ?? 0
    }
    
    var getWatchedEpisodes: Int {
        watchedEpisodes ?? 0
    }
    
    var getReadChapters: Int {
        readChapters ?? 0
    }
}
