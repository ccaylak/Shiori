import Foundation

struct MyListStatus: Decodable, Hashable {
    var status: String? = ""
    var score: Int = 0
        
    var numVolumesRead: Int? = 0
    var numChaptersRead: Int? = 0
    var numEpisodesWatched: Int? = 0
        
    var startDate: String? = ""
    var finishDate: String? = ""
    var comments: String? = ""
    var updatedAt: String? = ""
}

extension MyListStatus {
    var progressStatus: String {
        get { status ?? "Unknown" }
        set { status = newValue }
    }
    
    var readVolumes: Int {
        get { numVolumesRead ?? 0 }
        set { numVolumesRead = newValue }
    }
    
    var readChapters: Int {
        get { numChaptersRead ?? 0 }
        set { numChaptersRead = newValue }
    }
    
    var watchedEpisodes: Int {
        get { numEpisodesWatched ?? 0 }
        set { numEpisodesWatched = newValue }
    }
    
    var userComments: String {
        get { comments ?? "" }
        set { comments = newValue }
    }
    
    var startDateValue: String {
        get {startDate ?? ""}
        set {startDate = newValue}
    }
    
    var finishDateValue: String {
        get {finishDate ?? ""}
        set {finishDate = newValue}
    }
    
    var lastUpdate: String {
        updatedAt ?? ""
    }
}
