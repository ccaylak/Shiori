import Foundation
import SwiftUI

class MyAnimeListAPIController {
    
    @AppStorage("result") private var result = 10
    @AppStorage("animeRankingType") private var animeRankingType = AnimeSortType.all
    @AppStorage("mangaRankingType") private var mangaRankingType = MangaSortType.all
    
    private let baseURL = "https://api.myanimelist.net/v2"
    private let apiKey = Config.apiKey
    
    private let animePreviewFields: [ApiFields] = [.id, .title, .mainPicture, .numEpisodes, .mediaType, .startDate, .status]
    private var animeFields: [ApiFields] = [.numEpisodes, .mediaType, .startDate, .status, .mean, .synopsis, .genres, .recommendations, .endDate, .studios, .relatedAnime, .rank, .popularity, .pictures]
    
    private let mangaPreviewFields: [ApiFields] = [.id, .title, .mainPicture, .numChapters, .numVolumes, .mediaType, .startDate, .status]
    private let mangaFields: [ApiFields] = [.authors, .numChapters, .numVolumes, .mediaType, .startDate, .status,.endDate, .synopsis, .mean, .rank, .popularity, .genres, .mediaType, .pictures, .recommendations, .relatedManga]
    
    func loadAnimePreviews(searchTerm: String) async throws -> MediaResponse {
        var components = URLComponents(string: "\(baseURL)/anime")!
        components.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: animePreviewFields))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMediaResponse(data: data)
    }
    
    func loadAnimeDetails(animeId: Int) async throws -> Media {
        var components = URLComponents(string: "\(baseURL)/anime/\(animeId)")!
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: animeFields))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMedia(data: data)
    }
    
    func loadAnimeRankings() async throws -> MediaResponse {
        var components = URLComponents(string: "\(baseURL)/anime/ranking")!
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: animeRankingType.rawValue),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: animePreviewFields))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMediaResponse(data: data)
    }
    
    func loadMangaDetails(mangaId: Int) async throws -> Media {
        var components = URLComponents(string: "\(baseURL)/manga/\(mangaId)")!
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: mangaFields))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMedia(data: data)
    }
    
    func loadMangaPreviews(searchTerm: String) async throws -> MediaResponse {
        var components = URLComponents(string: "\(baseURL)/manga")!
        components.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: mangaPreviewFields))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMediaResponse(data: data)
    }
    
    func loadMangaRankings() async throws -> MediaResponse {
        var components = URLComponents(string: "\(baseURL)/manga/ranking")!
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: mangaRankingType.rawValue),
            URLQueryItem(name: "limit", value: "\(result)"),
            URLQueryItem(name: "fields", value: ApiFields.fieldsHeader(for: mangaPreviewFields))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMediaResponse(data: data)
    }
    
    func loadNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeMediaResponse(data: data)
    }
    
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        return request
    }
    
    private func fetchData(request: URLRequest) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    private func decodeMediaResponse(data: Data) throws -> MediaResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(MediaResponse.self, from: data)
    }
    
    private func decodeMedia(data: Data) throws -> Media {
        let decoder = JSONDecoder()
        return try decoder.decode(Media.self, from: data)
    }
}
