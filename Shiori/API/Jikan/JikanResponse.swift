import Foundation

struct JikanResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: AnimeManga
    
    struct AnimeManga: Decodable {
        enum CodingKeys: String, CodingKey {
            case anime, manga
        }
        
        let anime: AnimeStatistics
        let manga: MangaStatistics
        
        struct AnimeStatistics: Decodable {
            enum CodingKeys: String, CodingKey {
                case watching, completed, dropped
                case onHold = "on_hold"
                case planToWatch = "plan_to_watch"
            }
            
            let watching, completed, dropped, onHold, planToWatch: Int
        }
        
        struct MangaStatistics: Decodable {
            enum CodingKeys: String, CodingKey {
                case reading, completed, dropped
                case onHold = "on_hold"
                case planToRead = "plan_to_read"
            }
            
            let reading, completed, dropped, onHold, planToRead: Int
        }
    }
}
