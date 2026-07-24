import Foundation

enum AniListProfileError: Error {
    case invalidResponse
}

final class AniListProfileService {
    func fetchViewer(accessToken: String) async throws -> AniListViewer {
        let url = URL(
            string: "https://graphql.anilist.co"
        )!

        let query = """
        query {
          Viewer {
            id
            name
            avatar {
              large
            }
            siteUrl
            createdAt
          }
        }
        """

        let body = try JSONSerialization.data(
            withJSONObject: [
                "query": query
            ]
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, response) = try await URLSession.shared.data(
            for: request
        )

        guard
            let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
        else {
            throw AniListProfileError.invalidResponse
        }

        return try JSONDecoder()
            .decode(AniListViewerResponse.self, from: data)
            .data
            .viewer
    }
}
