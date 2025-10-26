import Foundation

@MainActor class SeasonController {
    
    private var settingsManager: SettingsManager = .shared
    
    func fetchSeason(year: Int, season: String) async throws -> SeasonResponse {
        var components: URLComponents = URLComponents(string: MALEndpoints.Anime.season(year: year, seasonName: season))!
        
        components.queryItems = [
            URLQueryItem(name: "sort", value: "anime_num_list_users"),
            URLQueryItem(name: "limit", value: "500"),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .otherTitles, .cover, .episodes, .mediaType, .status, .entryStatus])),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            print("JSON Response:", json)
        } catch {
            print("JSON parsing error:", error)
        }
        
        return try JSONDecoder().decode(SeasonResponse.self, from: data)
    }
}
