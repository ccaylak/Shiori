import Foundation
import SwiftUI
import KeychainSwift

class ProfileController {
    
    private let baseURL = "https://api.myanimelist.net/v2"
    private let apiKey = Config.apiKey
    private let keychain = KeychainSwift()
    
    func loadNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    func saveMangaProgress(mangaId: Int, status: String, score: Int, chapters: Int) async throws {
        let url = URL(string: "\(baseURL)/manga/\(mangaId)/my_list_status")!
        
        let parameters: [String: String] = [
            "status": status,
            "score": "\(score)",
            "num_chapters_read": "\(chapters)"
        ]
        let formBody = parameters.map { "\($0.key)=\($0.value)" }
                                 .joined(separator: "&")
        
        var request = buildRequest(url: url, httpMethod: "PUT")
        request.httpBody = formBody.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        print("Response: \(String(data: data, encoding: .utf8) ?? "No Data")")
    }


    
    func saveAnimeProgress(animeId: Int, status: String, score: Int, episodes: Int) async throws {
        var components = URLComponents(string: "\(baseURL)/anime/\(animeId)/my_list_status")!
        
        components.queryItems = [
            URLQueryItem(name: "status", value: "\(status)"),
            URLQueryItem(name: "score", value: "\(score)"),
            URLQueryItem(name: "num_watched_episodes", value: "\(episodes)")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "PUT")
        let (data, _) = try await URLSession.shared.data(for: request)
    }
    
    func fetchAnimeLibrary(status: String) async throws -> LibraryResponse {
        var components = URLComponents(string: "\(baseURL)/users/@me/animelist")!
        
        if (status != "all") {
            components.queryItems = [
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "sort", value: "list_updated_at"),
                URLQueryItem(name:"fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .startDate, .mediaType, .listStatus, .numEpisodes, .status])),
                URLQueryItem(name:"limit", value: "1000")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "sort", value: "list_updated_at"),
                URLQueryItem(name:"fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .startDate, .mediaType, .listStatus, .numEpisodes, .status])),
                URLQueryItem(name:"limit", value: "1000")
            ]
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(LibraryResponse.self, from: data)
    }
    
    func fetchMangaLibrary(status: String) async throws -> LibraryResponse {
        var components = URLComponents(string: "\(baseURL)/users/@me/mangalist")!
        
        if (status != "all") {
            components.queryItems = [
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "sort", value: "list_updated_at"),
                URLQueryItem(name:"fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .startDate, .mediaType, .listStatus, .numVolumes, .numChapters, .status])),
                URLQueryItem(name:"limit", value: "1000")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "sort", value: "list_updated_at"),
                URLQueryItem(name:"fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .startDate, .mediaType, .listStatus, .numVolumes, .numChapters, .status])),
                URLQueryItem(name:"limit", value: "1000")
            ]
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(LibraryResponse.self, from: data)
    }
    
    func deleteMangaListItem(mangaId: Int) async throws {
        let components = URLComponents(string: "\(baseURL)/manga/\(mangaId)/my_list_status")!
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "DELETE")
        try await URLSession.shared.data(for: request)
    }
    
    func deleteAnimeListItem(animeId: Int) async throws {
        let components = URLComponents(string: "\(baseURL)/anime/\(animeId)/my_list_status")!
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "DELETE")
        let (_, response) = try await URLSession.shared.data(for: request)
    }

    
    func fetchMangaStatistics (status: String) async throws -> Int {
        var components = URLComponents(string: "\(baseURL)/users/@me/mangalist")!
        components.queryItems = [
            URLQueryItem(name: "status", value: status)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArray = json["data"] as? [[String: Any]] {
            return dataArray.count
        }
        throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
    }
    
    func fetchUserProfile() async throws -> ProfileDetails {
        var components = URLComponents(string: "\(baseURL)/users/@me")!
        components.queryItems = [
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: [.id, .name, .picture, .gender, .birthday, .location, .joinedAt, .timeZone, .animeStatistics]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ProfileDetails.self, from: data)
    }
    
    func fetchNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    private func buildRequest(url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = keychain.get("accessToken"), !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        }
        
        return request
    }
}
