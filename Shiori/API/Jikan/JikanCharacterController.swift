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
        
        let character = try JSONDecoder().decode(JikanCharacter.self, from: data)
                
                // Drucke es in der Konsole
                print("Fetched character:", character)
                
                // Gib es zurück
                return character
    }
}
