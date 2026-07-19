import Foundation

@MainActor
final class JikanGenresController {
    
    func fetchAnimeGenres() async throws -> JikanGenre {
        let url = JikanEndpoints.Genres().anime
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "anime.genres"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanGenre.self, from: data)
    }
    
    func fetchAnimeByGenre(id: Int, page: Int) async throws -> JikanMedia {
        guard var components = URLComponents(
            url: JikanEndpoints.Studio.animes,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "genres", value: "\(id)"),
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
                endpoint: "anime.details.genre"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanMedia.self, from: data)
    }
    
    func fetchMangaGenres() async throws -> JikanGenre {
        let url = JikanEndpoints.Genres().manga
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "manga.genres"
        )
        
        let decoded = try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanGenre.self, from: data)
        
        // 👉 Doppelte Genres anhand von malId entfernen (letzter gewinnt) Bug melden
        let uniqueGenres = Dictionary(grouping: decoded.data, by: \.malId)
            .compactMap { $0.value.last }
        
        return JikanGenre(data: uniqueGenres)
    }
    
    func fetchMangaByGenre(id: Int, page: Int) async throws -> JikanMedia {
        guard var components = URLComponents(
            url: JikanEndpoints.Manga().search,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "genres", value: "\(id)"),
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
                endpoint: "manga.details.genre"
        )

        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanMedia.self, from: data)
    }
}
