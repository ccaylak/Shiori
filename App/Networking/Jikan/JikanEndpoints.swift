import Foundation
import SwiftUI

struct JikanEndpoints {
    @AppStorage("extendedDataSource") private static var apiService: APIService = APIService.jikan
    
    private static var apiBaseUrl: String {
        apiService.apiBaseUrl
    }
    
    private static func url(_ path: String) -> URL {
        let urlString = "\(apiBaseUrl)\(path)"
        
        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid Jikan endpoint URL: \(urlString)")
        }
        
        return url
    }
    
    struct Manga {
        var search: URL {
            JikanEndpoints.url("/manga")
        }
    }
    
    struct Anime {
        var search: URL {
            JikanEndpoints.url("/anime")
        }
    }
    
    struct Profile {
        let username: String
        
        var statistics: URL {
            JikanEndpoints.url("/users/\(username)/statistics")
        }
        
        var favorites: URL {
            JikanEndpoints.url("/users/\(username)/favorites")
        }
        
        var friends: URL {
            JikanEndpoints.url("/users/\(username)/friends")
        }
    }
    
    struct Character {
        let id: Int
        
        var anime: URL {
            JikanEndpoints.url("/anime/\(id)/characters")
        }
        
        var manga: URL {
            JikanEndpoints.url("/manga/\(id)/characters")
        }
        
        var full: URL {
            JikanEndpoints.url("/characters/\(id)/full")
        }
    }
    
    struct Relations {
        let id: Int
        
        var animeRelations: URL {
            JikanEndpoints.url("/anime/\(id)/relations")
        }
        
        var mangaRelations: URL {
            JikanEndpoints.url("/manga/\(id)/relations")
        }
    }
    
    struct Pictures {
        let id: Int
        
        var mangaPictures: URL {
            JikanEndpoints.url("/manga/\(id)/pictures")
        }
        
        var animePictures: URL {
            JikanEndpoints.url("/anime/\(id)/pictures")
        }
    }
    
    struct Person {
        let id: Int
        
        var full: URL {
            JikanEndpoints.url("/people/\(id)/full")
        }
    }
    
    struct Studio {
        let id: Int
        
        var studio: URL {
            JikanEndpoints.url("/producers/\(id)")
        }
        
        static var all: URL {
            JikanEndpoints.url("/producers")
        }
        
        static var animes: URL {
            JikanEndpoints.url("/anime")
        }
    }
    
    struct Genres {
        var anime: URL {
            JikanEndpoints.url("/genres/anime")
        }
        
        var manga: URL {
            JikanEndpoints.url("/genres/manga")
        }
    }
}
