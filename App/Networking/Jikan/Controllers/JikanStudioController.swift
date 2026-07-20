import Foundation

@MainActor
final class JikanStudioController {
    func fetchAnimeStudioById(id: Int, apiService: APIService) async throws -> JikanAnimeStudioResponse {
        let url = JikanEndpoints.Studio.details(id: id, apiService: apiService)
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "studio.details"
        )
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanAnimeStudioResponse.self, from: data)
    }
    
    func fetchAnimeStudios(searchTerm: String, order: String, sort: String, page: Int, apiService: APIService) async throws -> JikanStudio {
        guard var components = URLComponents(
            url: JikanEndpoints.Studio.all(apiService: apiService),
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "order_by", value: order),
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "anime.studios"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanStudio.self, from: data)
    }
    
    func fetchAnimesByAnimeStudio(id: Int, page: Int, apiService: APIService) async throws -> JikanMedia {
        guard var components = URLComponents(
            url: JikanEndpoints.Studio.anime(apiService: apiService),
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "producers", value: "\(id)"),
            URLQueryItem(name: "page", value: "\(page)"),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "studio.animes"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanMedia.self, from: data)
    }
}
