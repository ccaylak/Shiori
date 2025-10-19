import Foundation

enum MALApiFields: String {
    
    // General informations
    case id = "id"
    case title = "title"
    case otherTitles = "alternative_titles"
    case cover = "main_picture"
    case startDate = "start_date"
    case endDate = "end_date"
    case summary = "synopsis"
    case type = "type"
    case mean = "mean"
    case rank = "rank"
    case popularity = "popularity"
    case genres = "genres"
    case mediaType = "media_type"
    case status = "status"
    case recommendations = "recommendations{mean, num_episodes, num_volumes, num_chapters, media_type, alternative_titles}"
    case scoredUsers = "num_scoring_users"
    
    // anime related
    case episodes = "num_episodes"
    case studios = "studios"
    case relatedAnime = "related_anime{media_type, alternative_titles}"
    
    // manga related
    case volumes = "num_volumes"
    case chapters = "num_chapters"
    case relatedManga = "related_manga{media_type, alternative_titles}"
    case authors = "authors{first_name,last_name}"
    
    // profile related
    case username = "name"
    case profilePicture = "picture"
    case entryStatus = "my_list_status{status, num_volumes_read, num_chapters_read, score, comments, updated_at, start_date, finish_date}"
    case gender = "gender"
    case birthday = "birthday"
    case location = "location"
    case joinedAt = "joined_at"
    case timeZone = "time_zone"
    
    static func fieldsHeader(for fields: [MALApiFields]) -> String {
        return fields.map { $0.rawValue }.joined(separator: ",")
    }
}
