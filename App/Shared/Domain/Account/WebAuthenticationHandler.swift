import Foundation

typealias WebAuthenticationHandler = @MainActor (URL, String) async throws -> URL
