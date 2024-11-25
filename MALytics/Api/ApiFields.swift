import Foundation

enum ApiFields: String {
    case id = "id"
    case title = "title"
    case mainPicture = "main_picture"
    case startDate = "start_date"
    case endDate = "end_date"
    case synopsis = "synopsis"
    case type = "type"
    case mean = "mean"
    case rank = "rank"
    case popularity = "popularity"
    case genres = "genres"
    case mediaType = "media_type"
    case status = "status"
    case numEpisodes = "num_episodes"
    case numVolumes = "num_volumes"
    case numChapters = "num_chapters"
    case studios = "studios"
    case pictures = "pictures"
    case relatedAnime = "related_anime"
    case relatedManga = "related_manga"
    case recommendations = "recommendations"
    case authors = "authors{first_name,last_name}"
    
    static func fieldsHeader(for fields: [ApiFields]) -> String {
        return fields.map { $0.rawValue }.joined(separator: ",")
    }
}
