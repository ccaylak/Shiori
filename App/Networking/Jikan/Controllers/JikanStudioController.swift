import Foundation

@MainActor
final class JikanStudioController {
    func fetchAnimeStudioById(id: Int) async throws -> JikanAnimeStudioResponse {
        let url = JikanEndpoints.Studio(id: id).studio
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
    
    func fetchAnimeStudios(searchTerm: String, order: String, sort: String, page: Int) async throws -> JikanStudio {
        guard var components = URLComponents(
            url: JikanEndpoints.Studio.all,
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
    
    func fetchAnimesByAnimeStudio(id: Int, page: Int) async throws -> JikanMedia {
        guard var components = URLComponents(
            url: JikanEndpoints.Studio.animes,
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
