import Foundation
import SwiftUI

class MyAnimeListAPIController {
    
    @AppStorage("result") private var result = 10
    @AppStorage("rankingType") private var rankingType = RankingType.all
    
    private let baseURL = "https://api.myanimelist.net/v2/anime"
    private let animeEndpoint = "/anime"
    private let rankingEndpoint = "/ranking"
    private let mangeEndpoint = "/manga"
    private let apiKey = Config.apiKey
    
    private let previewFields = "id,title,main_picture,mean,num_episodes,media_type,start_date,status"
    
    func loadAnimeDetails(animeId: Int) async throws -> Anime {
        var components = URLComponents(string: baseURL + "/\(animeId)")!

        components.queryItems = [
            URLQueryItem(name: "fields", value: "mean,synopsis,mean,genres,status,recommendations,statistics,media_type,start_date,end_date,num_episodes,studios,related_anime,rank,popularity,pictures")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeAnime(data: data)
    }
    
    func loadAnimeRankings() async throws -> AnimeResponse {
        var components = URLComponents(string: baseURL + rankingEndpoint)!
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: rankingType.rawValue),
            URLQueryItem(name: "limit", value: String(result)),
            URLQueryItem(name: "fields", value: previewFields)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeAnimeResponse(data: data)
    }
    
    func loadNextPage(_ nextPage: String) async throws -> AnimeResponse {
        guard let url = URL(string: nextPage) else {
                throw URLError(.badURL)
            }
        
        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeAnimeResponse(data: data)
    }

    func loadAnimePreviews(searchTerm: String) async throws -> AnimeResponse {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(result)),
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "fields", value: previewFields)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let request = createRequest(url: url)
        let data = try await fetchData(request: request)
        return try decodeAnimeResponse(data: data)
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

    private func decodeAnimeResponse(data: Data) throws -> AnimeResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(AnimeResponse.self, from: data)
    }
    
    private func decodeAnime(data: Data) throws -> Anime {
        let decoder = JSONDecoder()
        return try decoder.decode(Anime.self, from: data)
    }
}
