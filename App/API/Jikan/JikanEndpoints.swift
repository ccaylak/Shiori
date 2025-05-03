import Foundation

struct JikanEndpoints {
    private static let baseURL = "https://api.jikan.moe/v4"
    
    struct Profile {
        let username: String
        
        var statistics: String {
            "\(baseURL)/users/\(username)/statistics"
        }
        
        var favorites: String {
            "\(baseURL)/users/\(username)/favorites"
        }
        
        var friends: String {
            "\(baseURL)/users/\(username)/friends"
        }
    }
    
    struct Character {
        let id: Int
        
        var anime: String {
            "\(baseURL)/anime/\(id)/characters"
        }
        
        var manga: String {
            "\(baseURL)/manga/\(id)/characters"
        }
    }
}
