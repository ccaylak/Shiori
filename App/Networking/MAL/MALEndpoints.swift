import Foundation

struct MALEndpoints {
    private static let apiBaseUrl = APIService.mal.apiBaseUrl

    private static func url(_ path: String) -> URL {
        let urlString = "\(apiBaseUrl)/\(path)"

        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid MAL endpoint: \(urlString)")
        }

        return url
    }

    struct Anime {
        let id: Int

        var details: URL {
            MALEndpoints.url("anime/\(id)")
        }

        var update: URL {
            MALEndpoints.url("anime/\(id)/my_list_status")
        }

        static var ranking: URL {
            MALEndpoints.url("anime/ranking")
        }

        static var list: URL {
            MALEndpoints.url("anime")
        }

        static func season(year: Int, seasonName: String) -> URL {
            MALEndpoints.url("anime/season/\(year)/\(seasonName)")
        }

        static var library: URL {
            MALEndpoints.url("users/@me/animelist")
        }
    }

    struct Manga {
        let id: Int

        var details: URL {
            MALEndpoints.url("manga/\(id)")
        }

        var update: URL {
            MALEndpoints.url("manga/\(id)/my_list_status")
        }

        static var list: URL {
            MALEndpoints.url("manga")
        }

        static var ranking: URL {
            MALEndpoints.url("manga/ranking")
        }

        static var library: URL {
            MALEndpoints.url("users/@me/mangalist")
        }
    }

    struct Profile {
        static var information: URL {
            MALEndpoints.url("users/@me")
        }
    }
}
