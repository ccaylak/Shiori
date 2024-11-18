import Foundation

struct Anime: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id, title, genres, recommendations, status
        case images = "main_picture"
        case mediaType = "media_type"
        case description = "synopsis"
        case rating = "mean"
        case episodes = "num_episodes"
        case startDate = "start_date"
    }
    
    let id: Int
    let title: String
    let images: Images
    let description: String?
    let rating: Double?
    let mediaType: String?
    let status: String?
    let episodes: Int?
    let genres: [Genre]?
    let startDate: String?
    let recommendations: [AnimeNode]?
    
    init(id: Int, title: String, images: Images, description: String? = nil, rating: Double? = nil, status: String? = nil, genres: [Genre]? = nil, recommendations: [AnimeNode]? = nil, startDate: String? = nil, mediaType: String? = nil, episodes: Int? = nil) {
        self.id = id
        self.title = title
        self.images = images
        self.description = description
        self.rating = rating
        self.status = status
        self.genres = genres
        self.recommendations = recommendations
        self.startDate = startDate
        self.mediaType = mediaType
        self.episodes = episodes
    }
}
