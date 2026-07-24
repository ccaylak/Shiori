import KeychainSwift

@MainActor
final class AniListTokenStore {
    private enum Key {
        static let accessToken = "anilist.accessToken"
    }

    private let keychain: KeychainSwift

    private(set) var accessToken: String?

    var isAuthenticated: Bool {
        accessToken != nil
    }

    init(keychain: KeychainSwift = KeychainSwift()) {
        self.keychain = keychain
        loadToken()
    }

    func setAccessToken(_ token: String) {
        accessToken = token
        keychain.set(token, forKey: Key.accessToken)
    }

    func clearToken() {
        accessToken = nil
        keychain.delete(Key.accessToken)
    }

    private func loadToken() {
        accessToken = keychain.get(Key.accessToken)
    }
}
