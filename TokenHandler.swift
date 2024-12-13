import Foundation
import KeychainSwift

class TokenHandler {
    
    private let keychain = KeychainSwift()
    
    func setToken(_ token: Data) {
        keychain.set(token, forKey: "accessToken")
    }
    
    func revokeToken() {
        keychain.delete("accessToken")
    }
    
    func isAuthenticated () -> Bool {
        return keychain.get("accessToken") != nil
    }
}
