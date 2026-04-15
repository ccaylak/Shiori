import Foundation

@MainActor public class JikanGenresController {
    
    func fetchAnimeGenres() async throws -> JikanGenre {
        let url = URL(string: JikanEndpoints.Genres().anime)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanGenre.self, from: data)
    }
    
    func fetchAnimeByGenre(id: Int, page: Int) async throws -> JikanMedia {
        var components = URLComponents(string: JikanEndpoints.Studio.animes)!
        
        components.queryItems = [
            URLQueryItem(name: "genres", value: "\(id)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanMedia.self, from: data)
    }
    
    func fetchMangaGenres() async throws -> JikanGenre {
        let url = URL(string: JikanEndpoints.Genres().manga)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanGenre.self, from: data)
        
        // 👉 Doppelte Genres anhand von malId entfernen (letzter gewinnt) Bug melden
        let uniqueGenres = Dictionary(grouping: decoded.data, by: \.malId)
            .compactMap { $0.value.last }
        
        return JikanGenre(data: uniqueGenres)
    }
    
    func fetchMangaByGenre(id: Int, page: Int) async throws -> JikanMedia {
        var components = URLComponents(string: "https://api.jikan.moe/v4/manga")!
        
        components.queryItems = [
            URLQueryItem(name: "genres", value: "\(id)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanMedia.self, from: data)
    }
}
