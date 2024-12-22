import Foundation

enum MALApiFields: String {
    
    // General informations
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
    case pictures = "pictures"
    case recommendations = "recommendations"
    case myListStatus = "my_list_status"
    case users = "num_scoring_users"
    
    // anime related
    case numEpisodes = "num_episodes"
    case numVolumes = "num_volumes"
    case studios = "studios"
    case relatedAnime = "related_anime"
    
    // manga related
    case numChapters = "num_chapters"
    case relatedManga = "related_manga"
    case authors = "authors{first_name,last_name}"
    
    // profile related
    case listStatus = "list_status"
    case name = "name"
    case picture = "picture"
    case gender = "gender"
    case birthday = "birthday"
    case location = "location"
    case joinedAt = "joined_at"
    case timeZone = "time_zone"
    case animeStatistics = "anime_statistics"
    
    static func fieldsHeader(for fields: [MALApiFields]) -> String {
        return fields.map { $0.rawValue }.joined(separator: ",")
    }
}
