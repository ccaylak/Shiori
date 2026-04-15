import Foundation
import SwiftUI

@MainActor class UserController {
    
    private var malService: MALService = .shared
    
    func fetchUserProfile() async throws -> User {
        var components = URLComponents(string: MALEndpoints.Profile.information)!
        components.queryItems = [
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.name, .picture, .gender, .birthday, .location, .joinedAt, .timeZone]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(User.self, from: data)
    }
    
    func fetchNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(MediaResponse.self, from: data)
    }
}
