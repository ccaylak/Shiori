import Foundation

struct Media: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id, title, genres, recommendations, status, studios, rank, popularity, authors
        case alternativeTitles = "alternative_titles"
        case images = "main_picture"
        case type = "media_type"
        case summary = "synopsis"
        case score = "mean"
        case episodes = "num_episodes"
        case startDate = "start_date"
        case endDate = "end_date"
        case relatedAnimes = "related_anime"
        case relatedMangas = "related_manga"
        case moreImages = "pictures"
        case numberOfVolumes = "num_volumes"
        case numberOfChapters = "num_chapters"
        case listStatus = "my_list_status"
        case users = "num_scoring_users"
    }
    
    // Pflichtfelder
    let id: Int
    let title: String
    let alternativeTitles: OtherTitles?
    let images: Images
    
    // Pflichtfelder optional
    let startDate: String?
    let episodes: Int?
    let status: String?
    let type: String?
    let numberOfVolumes: Int?
    let numberOfChapters: Int?
    let authors: [AuthorInfos]?
    let users: Int?
    
    // Optionale Felder für DetailsView
    let summary: String?
    let score: Double?
    let genres: [MediaGenre]?
    let endDate: String?
    let recommendations: [MediaNode]?
    let studios: [Studio]?
    let relatedAnimes: [MediaNode]?
    let relatedMangas: [MediaNode]?
    let rank: Int?
    let popularity: Int?
    let moreImages: [Images]?
    let listStatus: ListStatus?
    
    init(id: Int, title: String, alternativeTitles: OtherTitles? = nil, images: Images, startDate: String? = nil, type: String? = nil, status: String? = nil, episodes: Int? = nil, numberOfVolumes: Int? = nil, numberOfChapters: Int? = nil, authors: [AuthorInfos]? = nil, summary: String? = nil, score: Double? = nil, genres: [MediaGenre]? = nil, endDate: String? = nil, recommendations: [MediaNode]? = nil, studios: [Studio]? = nil, relatedAnimes: [MediaNode]? = nil, relatedMangas: [MediaNode]? = nil, rank: Int? = nil, popularity: Int? = nil, moreImages: [Images]? = nil, listStatus: ListStatus? = nil, users: Int? = nil) {
        self.id = id
        self.title = title
        self.alternativeTitles = alternativeTitles
        self.images = images
        self.startDate = startDate
        self.type = type
        self.status = status
        self.episodes = episodes
        self.numberOfVolumes = numberOfVolumes
        self.numberOfChapters = numberOfChapters
        self.authors = authors
        self.summary = summary
        self.score = score
        self.genres = genres
        self.endDate = endDate
        self.recommendations = recommendations
        self.studios = studios
        self.relatedAnimes = relatedAnimes
        self.relatedMangas = relatedMangas
        self.rank = rank
        self.popularity = popularity
        self.moreImages = moreImages
        self.listStatus = listStatus
        self.users = users
    }
}
