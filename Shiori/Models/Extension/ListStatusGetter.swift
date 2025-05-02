import Foundation

extension ListStatus {
    
    var getProgressStatus: ProgressStatus {
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
    
    private var progressStatusWrapper: ProgressStatus {
        if let animeStatus = ProgressStatus.Anime(rawValue: getStatusString) {
            return .anime(animeStatus)
        } else if let mangaStatus = ProgressStatus.Manga(rawValue: getStatusString) {
            return .manga(mangaStatus)
        }
        
        return .unknown
    }
    
}
