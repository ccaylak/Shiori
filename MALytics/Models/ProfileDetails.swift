import Foundation

struct ProfileDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, gender, location
        case profilePicture = "picture"
        case birthDate = "birthday"
        case joinDate = "joined_at"
        case timeZone = "time_zone"
        case animeStatistics = "anime_statistics"
    }
    
    let id: Int
    let name: String
    let profilePicture: String?
    let gender: String?
    let birthDate: String?
    let location: String?
    let joinDate: String?
    let timeZone: String?
    let animeStatistics: AnimeStatistics?
    
    init(id: Int, name: String, profilePicture: String? = nil, gender: String? = nil, birthDate: String? = nil, location: String? = nil, joinDate: String? = nil, timeZone: String? = nil, animeStatistics: AnimeStatistics? = nil) {
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
        self.gender = gender
        self.birthDate = birthDate
        self.location = location
        self.joinDate = joinDate
        self.timeZone = timeZone
        self.animeStatistics = animeStatistics
    }
    
    struct AnimeStatistics: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case watching = "num_items_watching"
            case completed = "num_items_completed"
            case onHold = "num_items_on_hold"
            case dropped = "num_items_dropped"
            case planToWatch = "num_items_plan_to_watch"
        }
        
        let watching: Int
        let completed: Int
        let onHold: Int
        let dropped: Int
        let planToWatch: Int
    }
}
