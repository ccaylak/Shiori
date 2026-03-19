import Foundation

struct TokenResponse: Decodable {
    
    private(set) var tokenType: String
    private(set) var expiresIn: Int
    private(set) var accessToken: String
    private(set) var refreshToken: String
}
