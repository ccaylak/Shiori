import Foundation

enum MALApiFields: String {
    
    // General informations
    case alternativeTitles = "alternative_titles"
    case startSeason = "start_season"
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
    case recommendations = "recommendations{my_list_status, mean, num_episodes, num_volumes, num_chapters, media_type, alternative_titles}"
    case numScoringUsers = "num_scoring_users"
    case numListUsers = "num_list_users"
    case averageEpisodeDuration = "average_episode_duration"
    
    // anime related
    case numEpisodes = "num_episodes"
    case studios = "studios"
    case relatedAnime = "related_anime{my_list_status, media_type, alternative_titles}"
    
    // manga related
    case numVolumes = "num_volumes"
    case numChapters = "num_chapters"
    case relatedManga = "related_manga{my_list_status, media_type, alternative_titles}"
    case authors = "authors{first_name,last_name}"
    
    // profile related
    case name = "name"
    case picture = "picture"
    case myListStatus = "my_list_status{status, num_episodes_watched, num_volumes_read, num_chapters_read, score, priority, comments, updated_at, start_date, finish_date}"
    case gender = "gender"
    case birthday = "birthday"
    case location = "location"
    case joinedAt = "joined_at"
    case timeZone = "time_zone"
    
    static func fieldsHeader(for fields: [MALApiFields]) -> String {
        return fields.map { $0.rawValue }.joined(separator: ",")
    }
}
