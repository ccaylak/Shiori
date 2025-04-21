import Foundation

struct ListStatus: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case status
        case rating = "score"
        case watchedEpisodes = "num_episodes_watched"
        case readChapters = "num_chapters_read"
        case readVolumes = "num_volumes_read"
        
    }
    
    let status: String?
    let rating: Int?
    let watchedEpisodes: Int?
    let readChapters: Int?
    let readVolumes: Int?
    
    init(status: String? = nil, rating: Int? = nil, watchedEpisodes: Int? = nil, readChapters: Int? = nil, readVolumes: Int? = nil) {
        self.status = status
        self.rating = rating
        self.watchedEpisodes = watchedEpisodes
        self.readChapters = readChapters
        self.readVolumes = readVolumes
    }
}
