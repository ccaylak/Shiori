import Foundation

import Foundation
import SwiftUI
import KeychainSwift

class MangaController {
    
    private let baseURL = "https://api.myanimelist.net/v2"
    private let apiKey = Config.apiKey
    private let keychain = KeychainSwift()
    
    func fetchMangaDetails(mangaId: Int) async throws -> Media {
        var components = URLComponents(string: "\(baseURL)/manga/\(mangaId)")!
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: [.authors, .numChapters, .numVolumes, .mediaType, .startDate, .status,.endDate, .synopsis, .mean, .rank, .popularity, .genres, .mediaType, .pictures, .recommendations, .relatedManga, .myListStatus]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Media.self, from: data)
    }
    
    func fetchMangaPreviews(searchTerm: String, result: Int) async throws -> MediaResponse {
        var components = URLComponents(string: "\(baseURL)/manga")!
        components.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .numChapters, .numVolumes, .mediaType, .startDate, .status]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    func fetchMangaRankings(result: Int, by: MangaSortType) async throws -> MediaResponse {
        var components = URLComponents(string: "\(baseURL)/manga/ranking")!
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: by.rawValue),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .numChapters, .numVolumes, .mediaType, .startDate, .status]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    func fetchNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    private func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = keychain.get("accessToken"), !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        }
        
        return request
    }
}

