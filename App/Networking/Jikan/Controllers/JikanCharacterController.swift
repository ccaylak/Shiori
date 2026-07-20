import Foundation

@MainActor
final class JikanCharacterController {
    
    func fetchAnimeCharacter(id: Int, apiService: APIService) async throws -> JikanCharacter {
        let url = JikanEndpoints.Character.anime(id: id, apiService: apiService)
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "anime.characters"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanCharacter.self, from: data)
    }
    
    func fetchMangaCharacter(id: Int, apiService: APIService) async throws -> JikanCharacter {
        let url = JikanEndpoints.Character.manga(id: id, apiService: apiService)
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "manga.characters"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanCharacter.self, from: data)
    }
    
    func fetchCharacterDetails(id: Int, apiService: APIService) async throws -> JikanCharacterFull {
        let url = JikanEndpoints.Character.full(id: id, apiService: apiService)
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "character.details"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanCharacterFull.self, from: data)
    }
}
