import Foundation

enum AniListAuthError: LocalizedError {
    case invalidLoginURL
    case missingAccessToken

    var errorDescription: String? {
        switch self {
        case .invalidLoginURL:
            "The AniList login URL could not be created."

        case .missingAccessToken:
            "AniList did not return an access token."
        }
    }
}

final class AniListAuthService {
    func generateLoginURL() throws -> URL {
        var components = URLComponents(
            string: "https://anilist.co/api/v2/oauth/authorize"
        )

        components?.queryItems = [
            URLQueryItem(
                name: "client_id",
                value: Config.aniListClientID
            ),
            URLQueryItem(
                name: "response_type",
                value: "token"
            )
        ]

        guard let url = components?.url else {
            throw AniListAuthError.invalidLoginURL
        }

        return url
    }

    func accessToken(from callbackURL: URL) throws -> String {
        guard
            let fragment = callbackURL.fragment,
            let components = URLComponents(
                string: "?\(fragment)"
            ),
            let accessToken = components.queryItems?
                .first(where: { $0.name == "access_token" })?
                .value
        else {
            throw AniListAuthError.missingAccessToken
        }

        return accessToken
    }
}
