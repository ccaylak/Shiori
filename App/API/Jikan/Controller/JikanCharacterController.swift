import Foundation

@MainActor class JikanCharacterController {
    
    func fetchAnimeCharacter(id: Int) async throws -> JikanCharacter {
        let url = URL(string: JikanEndpoints.Character(id: id).anime)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanCharacter.self, from: data)
    }
    
    func fetchMangaCharacter(id: Int) async throws -> JikanCharacter {
        let url = URL(string: JikanEndpoints.Character(id: id).manga)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanCharacter.self, from: data)
    }
    
    func fetchCharacterDetails(id: Int) async throws -> JikanCharacterFull {
        let url = URL(string: JikanEndpoints.Character(id: id).full)!
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        
        return try JSONDecoder().decode(JikanCharacterFull.self, from: data)
    }
}
