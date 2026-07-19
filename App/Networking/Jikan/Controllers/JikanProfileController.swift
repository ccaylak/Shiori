import Foundation

@MainActor
final class JikanProfileController {
    
    func fetchProfileStatistics(username: String) async throws -> JikanResponse {
        let url = JikanEndpoints.Profile(username: username).statistics
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "profile.statistics"
        )
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanResponse.self, from: data)
    }
    
    func fetchProfileFavorites(username: String) async throws -> JikanFavorites {
        let url = JikanEndpoints.Profile(username: username).favorites
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "profile.favorites"
        )
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanFavorites.self, from: data)
    }
    
    func fetchFriends(username: String) async throws -> JikanFriends {
        let url = JikanEndpoints.Profile(username: username).friends
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)

        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "profile.friends"
        )
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanFriends.self, from: data)
    }
}
