import Foundation
import SwiftUI

@MainActor class MangaController {
    
    private let baseURL = "https://api.myanimelist.net/v2"
    
    func addMangaToWatchList(mangaId: Int, status: String) async throws {
        let urlComponents = URLComponents(string: "\(baseURL)/manga/\(mangaId)/my_list_status")
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        let parameters = ["status": status]
        let bodyData = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        guard let bodyData else {
            print("Failed to encode body string")
            throw URLError(.cannotDecodeRawData)
        }

        var request = APIRequest.buildRequest(url: url, httpMethod: "PUT")
        request.httpBody = bodyData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        _ = try await URLSession.shared.data(for: request)
    }
    
    func fetchMangaDetails(mangaId: Int) async throws -> Media {
        var components = URLComponents(string: "\(baseURL)/manga/\(mangaId)")!
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: [.authors, .numChapters, .numVolumes, .mediaType, .startDate, .status,.endDate, .synopsis, .mean, .rank, .popularity, .genres, .mediaType, .pictures, .recommendations, .relatedManga, .myListStatus, .users]))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Media.self, from: data)
    }
    
    func fetchMangaPreviews(searchTerm: String, by: MangaSortType, result: Int) async throws -> MediaResponse {
        var components: URLComponents
        if searchTerm == "" {
            components = URLComponents(string: "\(baseURL)/manga/ranking")!
        } else {
            components = URLComponents(string: "\(baseURL)/manga")!
        }
        
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: by.rawValue),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: [.id, .title, .mainPicture, .numChapters, .numVolumes, .mediaType, .startDate, .status])),
            URLQueryItem(name: "q", value: searchTerm)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
}

