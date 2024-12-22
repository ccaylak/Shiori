import Foundation
import SwiftUI

@MainActor class ProfileController {
    
    func fetchMangaStatistics (status: String) async throws -> Int {
        var components = URLComponents(string: MALEndpoints.Manga.library)!
        components.queryItems = [
            URLQueryItem(name: "status", value: status)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArray = json["data"] as? [[String: Any]] {
            return dataArray.count
        }
        throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
    }
    
    func fetchUserProfile() async throws -> ProfileDetails {
        var components = URLComponents(string: MALEndpoints.Profile.information)!
        components.queryItems = [
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.id, .name, .picture, .gender, .birthday, .location, .joinedAt, .timeZone, .animeStatistics]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ProfileDetails.self, from: data)
    }
    
    func fetchNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
}
