import Foundation
import SwiftUI

@MainActor class MangaController {
    
    private var malService: MALService = .shared
    
    private var settingsManager: SettingsManager = .shared
    private var libraryManager: LibraryManager = .shared
    private var resultManager: ResultManager = .shared
    
    func saveProgress(id: Int, status: String, score: Int, chapters: Int, volumes: Int, comments: String, startDate: Date?, finishDate: Date?) async throws {
        let url = URL(string: MALEndpoints.Manga.update(id: id))!
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let parameters: [String: String] = [
            "status": status,
            "score": "\(score)",
            "num_chapters_read": "\(chapters)",
            "num_volumes_read": "\(volumes)",
            "comments": comments,
            "start_date": startDate.map { dateFormatter.string(from: $0) } ?? "",
            "finish_date": finishDate.map { dateFormatter.string(from: $0) } ?? ""
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
            "status": ProgressStatus.Manga.planToRead.rawValue,
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
    
    func completEntry(id: Int) async throws {
        let urlComponents = URLComponents(string: MALEndpoints.Manga.update(id: id))
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        let parameters: [String: String] = [
            "status": ProgressStatus.Manga.completed.rawValue,
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
    
    func increaseVolumes(id: Int, volume: Int) async throws {
        let urlComponents = URLComponents(string: MALEndpoints.Manga.update(id: id))
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        let parameters: [String: String] = ["num_volumes_read": String(volume)]
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
    
    func increaseChapters(id: Int, chapter: Int) async throws {
        let urlComponents = URLComponents(string: MALEndpoints.Manga.update(id: id))
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        let parameters: [String: String] = ["num_chapters_read": String(chapter)]
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
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.otherTitles, .authors, .chapters, .volumes, .mediaType, .startDate, .status,.endDate, .summary, .mean, .rank, .popularity, .genres, .mediaType, .recommendations, .relatedManga, .entryStatus, .scoredUsers]))
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
    
    func fetchPreviews(searchTerm: String) async throws -> MediaResponse {
        var components: URLComponents
        if searchTerm == "" {
            components = URLComponents(string: MALEndpoints.Manga.ranking)!
        } else {
            components = URLComponents(string: MALEndpoints.Manga.list)!
        }
        
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: resultManager.mangaRankingType.rawValue),
            URLQueryItem(name: "limit", value: String(settingsManager.resultsPerPage)),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.id, .title, .otherTitles, .cover, .chapters, .volumes, .mediaType, .startDate, .status])),
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "nsfw", value: String(settingsManager.showNsfwContent)),
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
    
    func fetchLibrary() async throws -> LibraryResponse {
        var components = URLComponents(string: MALEndpoints.Manga.library)!
        
        components.queryItems = (
            libraryManager.mangaProgressStatus != .all
            ? [URLQueryItem(name: "status", value: libraryManager.mangaProgressStatus.rawValue)]
            : []
        ) + [
            URLQueryItem(name: "sort", value: libraryManager.mangaSortOrder.rawValue),
            URLQueryItem(
                name: "fields",
                value: MALApiFields.fieldsHeader(for: [
                    .id, .title, .otherTitles, .cover, .startDate,
                    .mediaType, .entryStatus, .volumes, .chapters, .status
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
