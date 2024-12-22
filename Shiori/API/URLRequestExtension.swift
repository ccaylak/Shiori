import Foundation

@MainActor class APIRequest {
    
    private static let tokenHandler: TokenHandler = .shared
    private static let apiKey = Config.apiKey
    
    static func buildRequest(url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = tokenHandler.accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        }
        
        return request
    }
}
