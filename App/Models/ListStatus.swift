import Foundation

struct ListStatus: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case status, comments
        case rating = "score"
        case watchedEpisodes = "num_episodes_watched"
        case readChapters = "num_chapters_read"
        case readVolumes = "num_volumes_read"
        case startDate = "start_date"
        case finishDate = "finish_date"
        case lastUpdate = "updated_at"
    }
    
    let status: String?
    let rating: Int?
    let watchedEpisodes: Int?
    let readChapters: Int?
    let readVolumes: Int?
    let comments: String?
    let startDate: String?
    let finishDate: String?
    let lastUpdate: String?
    
    init(status: String? = nil, rating: Int? = nil, watchedEpisodes: Int? = nil, readChapters: Int? = nil, readVolumes: Int? = nil, comments: String? = nil, startDate: String? = nil, finishDate: String? = nil, lastUpdate: String? = nil) {
        self.status = status
        self.rating = rating
        self.watchedEpisodes = watchedEpisodes
        self.readChapters = readChapters
        self.readVolumes = readVolumes
        self.comments = comments
        self.startDate = startDate
        self.finishDate = finishDate
        self.lastUpdate = lastUpdate
    }
}
