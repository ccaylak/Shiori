struct AniListEndpoints {
    static var api: String {
        "https://graphql.anilist.co"
    }
    
    static var authorize: String {
        "https://anilist.co/api/v2/oauth/authorize"
    }
    
    static var token: String {
        "https://anilist.co/api/v2/oauth/token"
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
