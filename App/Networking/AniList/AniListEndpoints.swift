import Foundation

struct AniListEndpoints {
    private static let authBaseURL = "https://anilist.co/api/v2/oauth"

    private static func url(_ value: String) -> URL {
        guard let url = URL(string: value) else {
            preconditionFailure("Invalid AniList endpoint: \(value)")
        }

        return url
    }

    static var graphQL: URL {
        url(APIService.anilist.apiBaseUrl)
    }

    struct Auth {
        static var authorize: URL {
            url("\(authBaseURL)/authorize")
        }

        static var token: URL {
            url("\(authBaseURL)/token")
        }
    }
}

enum AniListQueries {
    static let airingByMalIds = """
    query AiringAnimeByMalIds(
        $malIds: [Int]
        $page: Int
    ) {
        Page(
            page: $page
            perPage: 50
        ) {
            pageInfo {
                currentPage
                hasNextPage
            }

            media(
                idMal_in: $malIds
                type: ANIME
                status: RELEASING
            ) {
                idMal

                title {
                    english
                    romaji
                    native
                }

                episodes

                nextAiringEpisode {
                    episode
                    airingAt
                    timeUntilAiring
                }
            }
        }
    }
    """
}
