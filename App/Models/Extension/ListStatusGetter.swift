import Foundation

extension ListStatus {
    
    var getProgressStatus: ProgressStatus {
        progressStatusWrapper
    }
    
    var getRating: Int {
        rating ?? 0
    }
    
    var getComments: String {
        comments ?? ""
    }
    
    var getWatchedEpisodes: Int {
        watchedEpisodes ?? 0
    }
    
    var getReadChapters: Int {
        readChapters ?? 0
    }
    
    var getReadVolumes: Int {
        readVolumes ?? 0
    }
    
    var getStartDate: String? {
        startDate ?? nil
    }
    
    var getEndDate: String? {
        finishDate ?? nil
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
