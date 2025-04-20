import Foundation

@MainActor class MALService {
    static let shared = MALService()
    
    private var tokenHandler: TokenHandler = .shared
    
    func refreshToken() async throws {
        var request = URLRequest(url: URL(string: "https://myanimelist.net/v1/oauth2/token")!)
        request.httpMethod = "POST"
        
        var requestBody = "client_id=\(Config.apiKey)&"
        requestBody += "grant_type=refresh_token&"
        requestBody += "refresh_token=\(tokenHandler.refreshToken!)"
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let content = try JSONDecoder().decode(TokenResponse.self, from: data)
        
        tokenHandler.setTokens(from: content)
    }
}
