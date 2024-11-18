import Foundation

struct Manga: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, status, genres, authors, recommendations
        case images = "main_picture"
        case startDate = "start_date"
        case endDate = "end_date"
        case description = "synopsis"
        case rating = "mean"
        case volumes = "num_volumes"
        case chapters = "num_chapters"
        case otherImages = "pictures"
        
    }
    
    let id: Int
    let title: String
    let images: Images
    
    let startDate: String?
    let endDate: String?
    let description: String?
    
    let rating: Double?
    let status: String?
    
    let genres: [Genre]?
    let volumes: Int?
    let chapters: Int?
    
    let authors: [AuthorInfos]?
    
    let otherImages: [Images]?
    
    let recommendations: [MangaNode]?
    
    init(id: Int, title: String, images: Images, startDate: String?, endDate: String?, description: String?, rating: Double?, status: String?, genres: [Genre]?, volumes: Int?, chapters: Int?, authors: [AuthorInfos]?, otherImages: [Images]?, recommendations: [MangaNode]?) {
        self.id = id
        self.title = title
        self.images = images
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.rating = rating
        self.status = status
        self.genres = genres
        self.volumes = volumes
        self.chapters = chapters
        self.authors = authors
        self.otherImages = otherImages
        self.recommendations = recommendations
    }
}
