import Foundation

@MainActor
final class AniListAccountClient: AccountClient {
    let provider: AccountProvider = .aniList

    private let authService: AniListAuthService
    private let profileService: AniListProfileService
    private let tokenStore: AniListTokenStore

    init(
        authService: AniListAuthService,
        profileService: AniListProfileService,
        tokenStore: AniListTokenStore
    ) {
        self.authService = authService
        self.profileService = profileService
        self.tokenStore = tokenStore
    }

    var isAuthenticated: Bool {
        tokenStore.isAuthenticated
    }

    func login(
        using authenticate: WebAuthenticationHandler
    ) async throws {
        let loginURL = try authService.generateLoginURL()

        let callbackURL = try await authenticate(
            loginURL,
            "shiori"
        )

        let accessToken = try authService.accessToken(
            from: callbackURL
        )

        tokenStore.setAccessToken(accessToken)
    }

    func fetchProfile() async throws -> AccountProfile {
        guard let accessToken = tokenStore.accessToken else {
            throw AniListAuthError.missingAccessToken
        }

        let viewer = try await profileService.fetchViewer(
            accessToken: accessToken
        )

        return AccountProfile(
            id: String(viewer.id),
            provider: .aniList,
            username: viewer.name,
            avatarURL: viewer.avatar?.large,
            profileURL: viewer.siteUrl,
            birthday: nil,
            joinedAt: viewer.createdAt.map {
                Date(
                    timeIntervalSince1970: TimeInterval($0)
                )
            },
            location: nil,
            gender: nil
        )
    }

    func logout() async throws {
        tokenStore.clearToken()
    }
}
