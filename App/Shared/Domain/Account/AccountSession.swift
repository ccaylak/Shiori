import Observation

@MainActor
@Observable
final class AccountSession {
    @ObservationIgnored
    private let malClient: MALAccountClient

    @ObservationIgnored
    private let aniListClient: AniListAccountClient

    private(set) var activeProvider: AccountProvider?
    private(set) var profile: AccountProfile?

    var isAuthenticated: Bool {
        activeProvider != nil
    }

    init(
        malClient: MALAccountClient,
        aniListClient: AniListAccountClient
    ) {
        self.malClient = malClient
        self.aniListClient = aniListClient

        restoreSession()
    }

    convenience init(
        malDependencies: MALDependencies
    ) {
        let malClient = MALAccountClient(
            authService: MALAuthService(),
            userController: malDependencies.userController,
            tokenStore: malDependencies.tokenStore
        )

        let aniListTokenStore = AniListTokenStore()

        let aniListClient = AniListAccountClient(
            authService: AniListAuthService(),
            profileService: AniListProfileService(),
            tokenStore: aniListTokenStore
        )

        self.init(
            malClient: malClient,
            aniListClient: aniListClient
        )
    }

    func login(
        with provider: AccountProvider,
        using authenticate: WebAuthenticationHandler
    ) async throws {
        let client = client(for: provider)

        try await client.login(using: authenticate)

        do {
            let fetchedProfile = try await client.fetchProfile()

            profile = fetchedProfile
            activeProvider = provider
        } catch {
            try? await client.logout()
            throw error
        }
    }

    func reloadProfile() async throws {
        guard let activeProvider else {
            return
        }

        profile = try await client(
            for: activeProvider
        ).fetchProfile()
    }

    func logout() async throws {
        guard let activeProvider else {
            return
        }

        try await client(for: activeProvider).logout()

        profile = nil
        self.activeProvider = nil
    }

    private func client(
        for provider: AccountProvider
    ) -> any AccountClient {
        switch provider {
        case .myAnimeList:
            malClient

        case .aniList:
            aniListClient
        }
    }

    private func restoreSession() {
        if malClient.isAuthenticated {
            activeProvider = .myAnimeList
        } else if aniListClient.isAuthenticated {
            activeProvider = .aniList
        }
    }
}
