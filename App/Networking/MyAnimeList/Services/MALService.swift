import Foundation
import TelemetryDeck

@MainActor
final class MALService {
    static let shared = MALService(
        tokenStore: .shared
    )
    
    private let tokenStore: TokenHandler
    
    init(tokenStore: TokenHandler) {
        self.tokenStore = tokenStore
    }
    
    func refreshToken() async throws {
        Metrics.authToken(.expired)
        
        guard let refreshToken = tokenStore.refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = URLRequest(url: URL(string: "https://myanimelist.net/v1/oauth2/token")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var requestBody = "client_id=\(Config.malKey)&"
        requestBody += "grant_type=refresh_token&"
        requestBody += "refresh_token=\(refreshToken)"
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: "/v1/oauth2/token")
        
        let content = try JSONDecoder
            .snakeCaseDecoder
            .decode(TokenResponse.self, from: data)
        
        tokenStore.setTokens(from: content)
        Metrics.authToken(.refreshed)
    }
}
