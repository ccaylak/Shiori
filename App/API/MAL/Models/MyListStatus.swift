import Foundation

struct MyListStatus: Decodable, Hashable {
    private(set) var status: String?
    private(set) var score: Int
    
    private(set) var numVolumesRead: Int?
    private(set) var numChaptersRead: Int?
    
    private(set) var numWatchedEpisodes: Int?
    
    private(set) var startDate: String?
    private(set) var finishDate: String?
    private(set) var comments: String?
    private(set) var updatedAt: String?
    
    init() {
        self.status = ""
        self.score = 0
        
        self.numVolumesRead = 0
        self.numChaptersRead = 0
        
        self.numWatchedEpisodes = 0
        
        self.startDate = ""
        self.finishDate = ""
        self.comments = ""
        self.updatedAt = ""
    }
}

extension MyListStatus {
    var readVolumes: Int {
        numVolumesRead ?? 0
    }
    
    var readChapters: Int {
        numChaptersRead ?? 0
    }
    
    var watchedEpisodes: Int {
        numWatchedEpisodes ?? 0
    }
    
    var userComments: String {
        comments ?? ""
    }
    
    var startDateValue: String {
        startDate ?? ""
    }
    
    var finishDateValue: String {
        finishDate ?? ""
    }
}
