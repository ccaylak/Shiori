import Foundation

@MainActor
final class SeasonController {
    private let requestBuilder: MALRequestBuilder
    private let malService: MALService
    
    init(requestBuilder: MALRequestBuilder, malService: MALService) {
        self.requestBuilder = requestBuilder
        self.malService = malService
    }
    
    convenience init() {
        self.init(
            requestBuilder: MALRequestBuilder(
                tokenStore: .shared
            ),
            malService: .shared
        )
    }
    
    func fetchSeason(
        year: Int,
        season: String,
        showNsfwContent: Bool
    ) async throws -> MediaResponse {
        guard var components = URLComponents(
            url: MALEndpoints.Anime.season(year: year, seasonName: season),
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "sort", value: "anime_num_list_users"),
            URLQueryItem(name: "limit", value: "500"),
            //URLQueryItem(name: "nsfw", value: String(showNsfwContent)),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.alternativeTitles, .numEpisodes, .mediaType, .status, .myListStatus, .numListUsers, .numScoringUsers, .genres])),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = requestBuilder.buildRequest(url: url, httpMethod: .get)
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(MediaResponse.self, from: data)
    }
}
