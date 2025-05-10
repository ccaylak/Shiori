import Foundation
import SwiftUI

@MainActor class AnimeController {
    
    private var malService: MALService = .shared
    
    private var libraryManager: LibraryManager = .shared
    private var settingsManager: SettingsManager = .shared
    private var resultManager: ResultManager = .shared
    
    func saveProgress(id: Int, status: String, score: Int, episodes: Int) async throws {
        let url = URL(string: MALEndpoints.Anime.update(id: id))!
        
        let parameters: [String: String] = [
            "status": status,
            "score": "\(score)",
            "num_watched_episodes": "\(episodes)"
        ]
        let formBody = parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        var request = APIRequest.buildRequest(url: url, httpMethod: "PUT")
        request.httpBody = formBody.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
    }
    
    func fetchPreviews(searchTerm: String) async throws -> MediaResponse {
        var components: URLComponents
        if searchTerm == "" {
            components = URLComponents(string: MALEndpoints.Anime.ranking)!
        } else {
            components = URLComponents(string: MALEndpoints.Anime.list)!
        }
        
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: resultManager.animeRankingType.rawValue),
            URLQueryItem(name: "limit", value: String(settingsManager.resultsPerPage)),
            URLQueryItem(name: "nsfw", value: String(settingsManager.showNsfwContent)),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .otherTitles, .cover, .episodes, .mediaType, .startDate, .status])),
            URLQueryItem(name: "q", value: searchTerm)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    func fetchDetails(id: Int) async throws -> Media {
        var components = URLComponents(string: MALEndpoints.Anime.details(id: id))!
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [
                .otherTitles, .episodes, .mediaType, .startDate, .status, .mean, .summary, .genres, .recommendations, .endDate, .studios, .relatedAnime, .rank, .popularity, .entryStatus, .scoredUsers,]))
        ]
        
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        return try JSONDecoder().decode(Media.self, from: data)
    }
    
    func addToWatchList(id: Int) async throws {
        let components = URLComponents(string: MALEndpoints.Anime.update(id: id))!
        
        let parameters = ["status": AnimeProgressStatus.planToWatch.rawValue]
        let bodyData = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: "PUT")
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
    }
    
    func fetchLibrary() async throws -> LibraryResponse {
        var components = URLComponents(string: MALEndpoints.Anime.library)!
        
        components.queryItems = (
            libraryManager.animeProgressStatus != .all
            ? [URLQueryItem(name: "status", value: libraryManager.animeProgressStatus.rawValue)]
            : []
        ) + [
            URLQueryItem(name: "sort", value: libraryManager.animeSortOrder.rawValue),
            URLQueryItem(
                name: "fields",
                value: MALApiFields.fieldsHeader(for: [
                    .id, .title, .otherTitles, .cover, .startDate,
                    .mediaType, .entryStatus, .episodes, .status
                ])
            ),
            URLQueryItem(name: "limit", value: "1000"),
            URLQueryItem(name: "nsfw", value: String(settingsManager.showNsfwContent))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        return try JSONDecoder().decode(LibraryResponse.self, from: data)
    }
    
    func deleteEntry(id: Int) async throws {
        let components = URLComponents(string: MALEndpoints.Anime.update(id: id))!
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "DELETE")
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
    }
}
