import Foundation
import KeychainSwift

@MainActor class TokenHandler: ObservableObject {
    static let shared = TokenHandler()

    private let keychain = KeychainSwift()

    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    @Published private(set) var isAuthenticated: Bool = false

    private init() {
        loadTokens()
    }

    private func loadTokens() {
        if let token = keychain.get("accessToken"),
           let refresh = keychain.get("refreshToken") {
            accessToken = token
            refreshToken = refresh
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }

    func setTokens(from content: TokenResponse) {
        guard let accessString = String(data: Data(content.accessToken.utf8), encoding: .utf8),
              let refreshString = String(data: Data(content.refreshToken.utf8), encoding: .utf8) else {
            print("Fehler beim Umwandeln der Tokens in String")
            return
        }

        keychain.set(accessString, forKey: "accessToken")
        keychain.set(refreshString, forKey: "refreshToken")

        accessToken = accessString
        refreshToken = refreshString

        isAuthenticated = true
    }

    func revokeTokens() {
        keychain.delete("accessToken")
        keychain.delete( "refreshToken")
        accessToken = nil
        refreshToken = nil
        isAuthenticated = false
    }
}
