import Foundation
import TelemetryDeck

final class APIRequest {
    static func buildRequest(url: URL,httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")

        return request
    }

    static func buildGraphQLRequest<Body: Encodable>(url: URL, body: Body) throws -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")

        request.httpBody = try JSONEncoder().encode(body)

        return request
    }

    static func validateResponse(
        _ response: URLResponse,
        api: APIService,
        endpoint: String
    ) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            Metrics.badStatusCode(
                api: api,
                httpStatusCode: httpResponse.statusCode,
                endpoint: endpoint
            )

            throw URLError(.badServerResponse)
        }
    }
}
