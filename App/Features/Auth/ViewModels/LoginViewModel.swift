import Observation

@MainActor
@Observable
final class LoginViewModel {
    private(set) var isAuthenticating = false
    private(set) var isLoadingProfile = false

    var errorMessage: String?

    func login(
        with provider: AccountProvider,
        session: AccountSession,
        authenticate: WebAuthenticationHandler
    ) async {
        guard !isAuthenticating else {
            return
        }

        isAuthenticating = true
        errorMessage = nil

        defer {
            isAuthenticating = false
        }

        do {
            try await session.login(
                with: provider,
                using: authenticate
            )
        } catch {
            errorMessage = error.localizedDescription
            print("Authentication failed:", error)
        }
    }

    func loadProfile(session: AccountSession) async {
        guard session.isAuthenticated else {
            return
        }

        isLoadingProfile = true

        defer {
            isLoadingProfile = false
        }

        do {
            try await session.reloadProfile()
        } catch {
            errorMessage = error.localizedDescription
            print("Profile loading failed:", error)
        }
    }

    func logout(session: AccountSession) async {
        do {
            try await session.logout()
        } catch {
            errorMessage = error.localizedDescription
            print("Logout failed:", error)
        }
    }
}
