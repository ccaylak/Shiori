import Foundation

enum JikanEndpoints {
    private static func url(_ path: String, apiService: APIService) -> URL {
        let urlString = "\(apiService.apiBaseUrl)\(path)"

        guard let url = URL(string: urlString) else {
            preconditionFailure(
                "Invalid Jikan endpoint URL: \(urlString)"
            )
        }

        return url
    }

    enum Manga {
        static func search(apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/manga",
                apiService: apiService
            )
        }
    }

    enum Anime {
        static func search(apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/anime",
                apiService: apiService
            )
        }
    }

    enum Profile {
        static func statistics(username: String, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/users/\(username)/statistics",
                apiService: apiService
            )
        }

        static func favorites(username: String, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/users/\(username)/favorites",
                apiService: apiService
            )
        }

        static func friends(username: String, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/users/\(username)/friends",
                apiService: apiService
            )
        }
    }

    enum Character {
        static func anime(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/anime/\(id)/characters",
                apiService: apiService
            )
        }

        static func manga(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/manga/\(id)/characters",
                apiService: apiService
            )
        }

        static func full(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/characters/\(id)/full",
                apiService: apiService
            )
        }
    }

    enum Relations {
        static func anime(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/anime/\(id)/relations",
                apiService: apiService
            )
        }

        static func manga(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/manga/\(id)/relations",
                apiService: apiService
            )
        }
    }

    enum Pictures {
        static func manga(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/manga/\(id)/pictures",
                apiService: apiService
            )
        }

        static func anime(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/anime/\(id)/pictures",
                apiService: apiService
            )
        }
    }

    enum Person {
        static func full(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/people/\(id)/full",
                apiService: apiService
            )
        }
    }

    enum Studio {
        static func details(id: Int, apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/producers/\(id)",
                apiService: apiService
            )
        }

        static func all(apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/producers",
                apiService: apiService
            )
        }

        static func anime(apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/anime",
                apiService: apiService
            )
        }
    }

    enum Genres {
        static func anime(apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/genres/anime",
                apiService: apiService
            )
        }

        static func manga(apiService: APIService) -> URL {
            JikanEndpoints.url(
                "/genres/manga",
                apiService: apiService
            )
        }
    }
}
