import Foundation

struct AiringResponse: Decodable {
    let data: ResponseData?
    let errors: [GraphQLError]?

    struct ResponseData: Decodable {
        let page: Page

        enum CodingKeys: String, CodingKey {
            case page = "Page"
        }
    }

    struct Page: Decodable {
        let pageInfo: PageInfo
        let media: [Media]
    }

    struct PageInfo: Decodable {
        let currentPage: Int
        let hasNextPage: Bool
    }

    struct Media: Decodable {
        let idMal: Int?
        let title: Title
        let episodes: Int?
        let nextAiringEpisode: AiringEpisode?
    }

    struct Title: Decodable {
        let english: String?
        let romaji: String?
        let native: String?
    }

    struct AiringEpisode: Decodable {
        let episode: Int
        let airingAt: Int

        var airingDate: Date {
            Date(timeIntervalSince1970: TimeInterval(airingAt))
        }
    }

    struct GraphQLError: Decodable, Error {
        let message: String
        let status: Int?
    }
}
