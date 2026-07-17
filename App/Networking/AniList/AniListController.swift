import Foundation

@MainActor
class AniListController {
    func fetchAiringAnime(
        malIds: [Int],
        page: Int = 1
    ) async throws -> AiringResponse {
        let url = URL(string: AniListEndpoints.api)!
        
        let variables = AiringVariables(
            malIds: malIds,
            page: page
        )
        
        let body = AniListRequest(
            query: AniListQueries.airingByMalIds,
            variables: variables
        )
        
        let request = try APIRequest.buildGraphQLRequest(url: url, body: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try APIRequest.validateResponse(
            response,
            api: APIService.anilist,
            endpoint: "AiringByMalIds"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(AiringResponse.self, from: data)
    }
}
