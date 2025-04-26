import Foundation

extension ListStatus {
    
    var getProgressStatus: ProgressStatusWrapper {
        progressStatusWrapper
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
    
    private var getStatusString: String {
        status ?? "Unknown"
    }
    
    private var progressStatusWrapper: ProgressStatusWrapper {
        if let animeStatus = AnimeProgressStatus(rawValue: getStatusString) {
            return .anime(animeStatus)
        } else if let mangaStatus = MangaProgressStatus(rawValue: getStatusString) {
            return .manga(mangaStatus)
        }
        
        return .unknown
    }
    
}
