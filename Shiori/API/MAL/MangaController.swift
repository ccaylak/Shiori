import Foundation
import SwiftUI

@MainActor class MangaController {
    
    private var malService: MALService = .shared
    
    func saveProgress(id: Int, status: String, score: Int, chapters: Int) async throws {
        let url = URL(string: MALEndpoints.Manga.update(id: id))!
        
        let parameters: [String: String] = [
            "status": status,
            "score": "\(score)",
            "num_chapters_read": "\(chapters)"
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
    
    func addToReadingList(id: Int) async throws {
        let urlComponents = URLComponents(string: MALEndpoints.Manga.update(id: id))
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        let parameters: [String: String] = [
            "status": MangaProgressStatus.planToRead.rawValue,
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
    
    func fetchDetails(id: Int) async throws -> Media {
        var components = URLComponents(string: MALEndpoints.Manga.details(id: id))!
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.authors, .numChapters, .numVolumes, .mediaType, .startDate, .status,.endDate, .synopsis, .mean, .rank, .popularity, .genres, .mediaType, .pictures, .recommendations, .relatedManga, .myListStatus, .users]))
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
    
    func fetchPreviews(searchTerm: String, by: MangaSortType, result: Int) async throws -> MediaResponse {
        var components: URLComponents
        if searchTerm == "" {
            components = URLComponents(string: MALEndpoints.Manga.ranking)!
        } else {
            components = URLComponents(string: MALEndpoints.Manga.list)!
        }
        
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: by.rawValue),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .numChapters, .numVolumes, .mediaType, .startDate, .status])),
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
    
    func fetchLibrary(status: String, sortOrder: String) async throws -> LibraryResponse {
        var components = URLComponents(string: MALEndpoints.Manga.library)!
        
            components.queryItems = [
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "sort", value: sortOrder),
                URLQueryItem(name:"fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .startDate, .mediaType, .listStatus, .numVolumes, .numChapters, .status])),
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
        let components = URLComponents(string: MALEndpoints.Manga.update(id: id))!
        
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
