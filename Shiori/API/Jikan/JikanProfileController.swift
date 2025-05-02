import Foundation

@MainActor public class JikanProfileController {
    
    func fetchProfileStatistics(username: String) async throws -> JikanResponse {
        let url = URL(string: JikanEndpoints.Profile(username: username).statistics)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanResponse.self, from: data)
    }
    
    func fetchProfileFavorites(username: String) async throws -> JikanFavorites {
        let url = URL(string: JikanEndpoints.Profile(username: username).favorites)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanFavorites.self, from: data)
    }
    
    func fetchFriends(username: String) async throws -> JikanFriends {
        let url = URL(string: JikanEndpoints.Profile(username: username).friends)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(JikanFriends.self, from: data)
    }
}
