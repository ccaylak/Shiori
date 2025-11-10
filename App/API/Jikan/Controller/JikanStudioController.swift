import Foundation

@MainActor class JikanStudioController {
    func fetchAnimeStudioById(id: Int) async throws -> JikanAnimeStudioResponse {
        let url = URL(string: JikanEndpoints.Studio(id: id).studio)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanAnimeStudioResponse.self, from: data)
    }
    
    func fetchAnimeStudios(searchTerm: String, order: String, sort: String, page: Int) async throws -> JikanAnimeStudio {
        var components = URLComponents(string: JikanEndpoints.Studio.all)!
        
        components.queryItems = [
            URLQueryItem(name: "order_by", value: order),
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanAnimeStudio.self, from: data)
    }
    
    func fetchAnimesByAnimeStudio(id: Int, page: Int) async throws -> JikanAnime {
        var components = URLComponents(string: JikanEndpoints.Studio.animes)!
        
        components.queryItems = [
            URLQueryItem(name: "producers", value: "\(id)"),
            URLQueryItem(name: "page", value: "\(page)"),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanAnime.self, from: data)
    }
}
