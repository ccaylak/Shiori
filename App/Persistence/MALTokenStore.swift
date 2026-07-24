import KeychainSwift
import Observation

@MainActor
@Observable
final class MALTokenStore {
    private enum Key {
        static let accessToken = "mal.accessToken"
        static let refreshToken = "mal.refreshToken"
    }

    @ObservationIgnored
    private let keychain: KeychainSwift

    private(set) var accessToken: String?
    private(set) var refreshToken: String?

    var isAuthenticated: Bool {
        accessToken != nil && refreshToken != nil
    }

    init(keychain: KeychainSwift = KeychainSwift()) {
        self.keychain = keychain
        loadTokens()
    }

    func setTokens(from response: TokenResponse) {
        accessToken = response.accessToken
        refreshToken = response.refreshToken

        keychain.set(
            response.accessToken,
            forKey: Key.accessToken
        )

        keychain.set(
            response.refreshToken,
            forKey: Key.refreshToken
        )
    }

    func revokeTokens() {
        accessToken = nil
        refreshToken = nil

        keychain.delete(Key.accessToken)
        keychain.delete(Key.refreshToken)
    }

    private func loadTokens() {
        accessToken = keychain.get(Key.accessToken)
        refreshToken = keychain.get(Key.refreshToken)
    }
}
