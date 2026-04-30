import Foundation
import TelemetryDeck

@MainActor class APIRequest {
    
    private static let tokenHandler: TokenHandler = .shared
    private static let apiKey = Config.apiKey
    
    static func buildRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = tokenHandler.accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        }
        
        return request
    }

    static func validateResponse(_ response: URLResponse, api: String, endpoint: String) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            TelemetryDeck.errorOccurred(
                id: "API.badStatusCode",
                parameters: [
                    "api": api,
                    "statusCode": "\(httpResponse.statusCode)",
                    "endpoint": endpoint
                ]
            )

            throw URLError(.badServerResponse)
        }
    }
}
