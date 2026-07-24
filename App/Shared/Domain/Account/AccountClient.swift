import Foundation

@MainActor
protocol AccountClient {
    var provider: AccountProvider { get }
    var isAuthenticated: Bool { get }

    func login(using authenticate: WebAuthenticationHandler) async throws

    func fetchProfile() async throws -> AccountProfile

    func logout() async throws
}
