import Foundation

struct MALEndpoints {
    private static let baseURL = "https://api.myanimelist.net/v2"
    
    struct Anime {
        private static let animeURL = "\(baseURL)/anime"
        
        static let list = animeURL
        static let ranking = "\(animeURL)/ranking"
        static func details(id: Int) -> String {
            "\(animeURL)/\(id)"
        }
        static func update(id: Int) -> String {
            "\(animeURL)/\(id)/my_list_status"
        }
        static let library = "\(baseURL)/users/@me/animelist"
    }
    
    struct Manga {
        private static let mangaURL = "\(baseURL)/manga"
        
        static let list = mangaURL
        static let ranking = "\(mangaURL)/ranking"
        static func details(id: Int) -> String {
            "\(mangaURL)/\(id)"
        }
        static func update(id: Int) -> String {
            "\(mangaURL)/\(id)/my_list_status"
        }
        static let library = "\(baseURL)/users/@me/mangalist"
    }
    
    struct Profile {
        static let information = "\(baseURL)/users/@me"
    }
}
