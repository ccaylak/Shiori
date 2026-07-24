import Foundation

@MainActor
final class MALRequestBuilder {
    private let tokenStore: TokenHandler

    init(tokenStore: TokenHandler) {
        self.tokenStore = tokenStore
    }

    func buildRequest(
        url: URL,
        httpMethod: HTTPMethod
    ) -> URLRequest {
        var request = APIRequest.buildRequest(
            url: url,
            httpMethod: httpMethod
        )

        if let accessToken = tokenStore.accessToken {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        } else {
            request.setValue(
                Config.malKey,
                forHTTPHeaderField: "X-MAL-CLIENT-ID"
            )
        }

        return request
    }
}
