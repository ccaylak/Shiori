import Foundation

struct ListStatus: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case status
        case rating = "score"
        case readVolumes = "num_volumes_read"
        case readChapters = "num_chapters_read"
        
    }
    
    let status: String?
    let rating: Int?
    let readVolumes: Int?
    let readChapters: Int?
    
    init(status: String? = nil, rating: Int? = nil, readVolumes: Int? = nil, readChapters: Int? = nil) {
        self.status = status
        self.rating = rating
        self.readVolumes = readVolumes
        self.readChapters = readChapters
    }
}
