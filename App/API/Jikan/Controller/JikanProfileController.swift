import Foundation

@MainActor public class JikanProfileController {
    
    func fetchProfileStatistics(username: String) async throws -> JikanResponse {
        let url = URL(string: JikanEndpoints.Profile(username: username).statistics)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanResponse.self, from: data)
    }
    
    func fetchProfileFavoritesXD(username: String) async throws -> JikanFavorites {
        let url = URL(string: JikanEndpoints.Profile(username: username).favorites)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanFavorites.self, from: data)
    }
    
    func fetchProfileFavorites(username: String) async throws -> JikanFavorites {
        let url = URL(string: JikanEndpoints.Profile(username: username).favorites)!
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        
        print("➡️ fetchProfileFavorites started for username: \(username)")
        print("➡️ URL: \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("⬅️ Status Code: \(httpResponse.statusCode)")
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("⬅️ Response Body: \(jsonString)")
            } else {
                print("⬅️ Response Body could not be converted to String")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw URLError(.badServerResponse)
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("❌ Request failed with status code: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
            
            let decoded = try JSONDecoder.snakeCaseDecoder.decode(JikanFavorites.self, from: data)
            print("✅ fetchProfileFavorites decoded successfully")
            return decoded
            
        } catch {
            print("❌ fetchProfileFavorites failed: \(error)")
            throw error
        }
    }
    
    func fetchFriends(username: String) async throws -> JikanFriends {
        let url = URL(string: JikanEndpoints.Profile(username: username).friends)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanFriends.self, from: data)
    }
}
