import Foundation
import SwiftUI

@MainActor
final class UserController {
    private let requestBuilder: MALRequestBuilder
    private let malService: MALService
    
    init(requestBuilder: MALRequestBuilder, malService: MALService) {
        self.requestBuilder = requestBuilder
        self.malService = malService
    }
    
    convenience init() {
        self.init(
            requestBuilder: MALRequestBuilder(
                tokenStore: .shared
            ),
            malService: .shared
        )
    }
    
    func fetchUserProfile() async throws -> User {
        guard var components = URLComponents(
            url: MALEndpoints.Profile.information,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.name, .picture, .gender, .birthday, .location, .joinedAt, .timeZone]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = requestBuilder.buildRequest(url: url, httpMethod: .get)
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
        
        let request = requestBuilder.buildRequest(url: url, httpMethod: .get)
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
