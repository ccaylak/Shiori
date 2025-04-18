import Foundation
import SwiftUI

@MainActor class AnimeController {
    
    private var malService: MALService = .shared
    
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
    
    func fetchPreviews(searchTerm: String, by: AnimeSortType, result: Int) async throws -> MediaResponse {
        var components: URLComponents
        if searchTerm == "" {
            components = URLComponents(string: MALEndpoints.Anime.ranking)!
        } else {
            components = URLComponents(string: MALEndpoints.Anime.list)!
        }
        
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: by.rawValue),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .numEpisodes, .mediaType, .startDate, .status])),
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
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.numEpisodes, .mediaType, .startDate, .status, .mean, .synopsis, .genres, .recommendations, .endDate, .studios, .relatedAnime, .rank, .popularity, .pictures, .myListStatus, .users]))
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
    
    func fetchLibrary(status: String, sortOrder: String) async throws -> LibraryResponse {
        var components = URLComponents(string: MALEndpoints.Anime.library)!
        
            components.queryItems = [
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "sort", value: sortOrder),
                URLQueryItem(name:"fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .startDate, .mediaType, .listStatus, .numEpisodes, .status])),
                URLQueryItem(name:"limit", value: "1000")
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
