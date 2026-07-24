import Foundation

@MainActor
final class MALAccountClient: AccountClient {
    let provider: AccountProvider = .myAnimeList

    private let authService: MALAuthService
    private let userController: UserController
    private let tokenStore: TokenHandler

    init(
        authService: MALAuthService,
        userController: UserController,
        tokenStore: TokenHandler
    ) {
        self.authService = authService
        self.userController = userController
        self.tokenStore = tokenStore
    }

    var isAuthenticated: Bool {
        tokenStore.isAuthenticated
    }

    func login(
        using authenticate: WebAuthenticationHandler
    ) async throws {
        guard let loginURL = authService.generateLoginURL() else {
            throw URLError(.badURL)
        }

        let callbackURL = try await authenticate(
            loginURL,
            "yourapp"
        )

        let tokenResponse = try await authService.exchangeCode(
            from: callbackURL
        )

        tokenStore.setTokens(from: tokenResponse)
    }

    func fetchProfile() async throws -> AccountProfile {
        let user = try await userController.fetchUserProfile()

        return AccountProfile(
            id: String(user.id),
            provider: .myAnimeList,
            username: user.name,
            avatarURL: user.picture,
            profileURL:
                "https://myanimelist.net/profile/\(user.name)",
            birthday: parseBirthday(user.birthday),
            joinedAt: parseJoinedAt(user.joinedAt),
            location: user.location,
            gender: user.gender
        )
    }

    func logout() async throws {
        tokenStore.revokeTokens()
    }

    private func parseBirthday(
        _ value: String?
    ) -> Date? {
        guard let value, !value.isEmpty else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.calendar = Calendar(
            identifier: .gregorian
        )
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.timeZone = TimeZone(
            secondsFromGMT: 0
        )
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.date(from: value)
    }

    private func parseJoinedAt(
        _ value: String?
    ) -> Date? {
        guard let value, !value.isEmpty else {
            return nil
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withColonSeparatorInTimeZone
        ]

        return formatter.date(from: value)
    }
}
