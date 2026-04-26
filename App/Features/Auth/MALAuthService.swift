import Foundation

final class MALAuthService {
    
    static let shared = MALAuthService()
    
    private init() {}
    
    private var codeVerifier: String = ""
    
    func generateLoginURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "myanimelist.net"
        components.path = "/v1/oauth2/authorize"
        
        codeVerifier = generateCodeVerifier()
        
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Config.apiKey),
            URLQueryItem(name: "state", value: UUID().uuidString),
            URLQueryItem(name: "code_challenge", value: codeVerifier),
            URLQueryItem(name: "code_challenge_method", value: "plain")
        ]
        
        return components.url
    }
    
    func exchangeCode(from callbackURL: URL) async throws -> TokenResponse {
        guard let code = extractCode(from: callbackURL) else {
            throw AuthError.missingCode
        }
        
        let url = URL(string: "https://myanimelist.net/v1/oauth2/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "client_id": Config.apiKey,
            "code": code,
            "code_verifier": codeVerifier,
            "grant_type": "authorization_code"
        ]
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")
        
        request.httpBody = body.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.tokenExchangeFailed
        }
        
        return try JSONDecoder
            .snakeCaseDecoder
            .decode(TokenResponse.self, from: data)
    }
    
    private func extractCode(from url: URL) -> String? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == "code" })?
            .value
    }
    
    private func generateCodeVerifier() -> String {
        let allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        
        return String((0..<128).compactMap { _ in
            allowedCharacters.randomElement()
        })
    }
}

enum AuthError: Error {
    case missingCode
    case tokenExchangeFailed
}
