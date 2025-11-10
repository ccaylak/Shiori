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
        
        var full: String {
            "\(baseURL)/characters/\(id)/full"
        }
    }
    
    struct Relations {
        let id: Int
        
        var animeRelations: String {
            "\(baseURL)/anime/\(id)/relations"
        }
        
        var mangaRelations: String {
            "\(baseURL)/manga/\(id)/relations"
        }
    }
    
    struct Pictures {
        let id: Int
        
        var mangaPictures: String {
            "\(baseURL)/manga/\(id)/pictures"
        }
        
        var animePictures: String {
            "\(baseURL)/anime/\(id)/pictures"
        }
    }
    
    struct Person {
        let id: Int
        
        var full: String {
            "\(baseURL)/people/\(id)/full"
        }
    }
    
    struct Studio {
        let id: Int
        
        var studio: String {
            "\(baseURL)/producers/\(id)"
        }
        
        static var all: String {
            "\(baseURL)/producers"
        }
        
        static var animes: String {
            "\(baseURL)/anime"
        }
    }
    
    struct Genres {
        var anime: String {
            "\(baseURL)/genres/anime"
        }
        
        var manga: String {
            "\(baseURL)/genres/manga"
        }
    }
}
