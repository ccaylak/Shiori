import Foundation

struct JikanEndpoints {
    private static let baseURL = "https://api.jikan.moe/v4"
    
    struct Profile {
        let username: String
        
        var statistics: String {
            "\(baseURL)/users/\(username)/statistics"
        }
    }
}
