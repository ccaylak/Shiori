import Foundation

struct MALEndpoints {
    private static let baseURL = "https://api.myanimelist.net/v2"
    
    struct Anime {
        let id: Int

        var details: String {
            "\(baseURL)/anime/\(id)"
        }
        
        var update: String {
            "\(baseURL)/anime/\(id)/my_list_status"
        }
        
        static var ranking: String {
            "\(baseURL)/anime/ranking"
        }
        
        static var list: String {
            "\(baseURL)/anime"
        }
        
        static func season(year: Int, seasonName: String) -> String {
            "\(baseURL)/anime/season/\(year)/\(seasonName)"
        }
        
        static var library: String {
            "\(baseURL)/users/@me/animelist"
        }
    }
    
    struct Manga {
        let id: Int
        
        var details: String {
            "\(baseURL)/manga/\(id)"
        }
        
        var update: String {
            "\(baseURL)/manga/\(id)/my_list_status"
        }
        
        static var list: String {
            "\(baseURL)/manga"
        }
        
        static var ranking: String {
            "\(baseURL)/manga/ranking"
        }
        
        static var library: String {
            "\(baseURL)/users/@me/mangalist"
        }
    }
    
    struct Profile {
        static var information: String {
            "\(baseURL)/users/@me"
        }
    }
}
