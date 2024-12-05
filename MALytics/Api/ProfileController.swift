import Foundation
import SwiftUI
import KeychainSwift

class ProfileController {
    
    @AppStorage("result") private var result = 10
    @AppStorage("animeRankingType") private var animeRankingType = AnimeSortType.all
    @AppStorage("mangaRankingType") private var mangaRankingType = MangaSortType.all
    
    private let baseURL = "https://api.myanimelist.net/v2"
    private let apiKey = Config.apiKey
    private let keychain = KeychainSwift()
    
    private let animePreviewFields: [ApiFields] = [.id, .title, .mainPicture, .numEpisodes, .mediaType, .startDate, .status]
    private var animeFields: [ApiFields] = [.numEpisodes, .mediaType, .startDate, .status, .mean, .synopsis, .genres, .recommendations, .endDate, .studios, .relatedAnime, .rank, .popularity, .pictures]
    
    private let mangaPreviewFields: [ApiFields] = [.id, .title, .mainPicture, .numChapters, .numVolumes, .mediaType, .startDate, .status]
    private let mangaFields: [ApiFields] = [.authors, .numChapters, .numVolumes, .mediaType, .startDate, .status,.endDate, .synopsis, .mean, .rank, .popularity, .genres, .mediaType, .pictures, .recommendations, .relatedManga]
    
    func loadNextPage(_ nextPage: String) async throws -> MediaResponse {
        guard let url = URL(string: nextPage) else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(MediaResponse.self, from: data)
    }
    
    func fetchMangaLibrary(status: String) async throws -> MangaLibraryStatus {
        var components = URLComponents(string: "https://api.myanimelist.net/v2/users/@me/mangalist")!
        
        if (status != "all") {
            components.queryItems = [
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "sort", value: "list_updated_at"),
                URLQueryItem(name:"fields", value: "id,title,main_picture,start_date,media_type,list_status,num_volumes,num_chapters"),
                URLQueryItem(name:"limit", value: "1000")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "sort", value: "list_updated_at"),
                URLQueryItem(name:"fields", value: "id,title,main_picture,start_date,media_type,list_status,num_volumes,num_chapters"),
                URLQueryItem(name:"limit", value: "1000")
            ]
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(MangaLibraryStatus.self, from: data)
    }
    
    func deleteMangaListItem(mangaId: Int) async throws {
        let components = URLComponents(string: "https://api.myanimelist.net/v2/manga/\(mangaId)/my_list_status")!
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(keychain.get("accessToken")!)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:
                print("Manga erfolgreich gelöscht.")
            case 404:
                throw URLError(.badServerResponse)
            default:
                throw URLError(.unknown)
            }
        } else {
        
            throw URLError(.unknown)
        }
    }

    
    func fetchMangaStatistics (status: String) async throws -> Int {
        var components = URLComponents(string: "https://api.myanimelist.net/v2/users/@me/mangalist")!
        components.queryItems = [
            URLQueryItem(name: "status", value: status)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArray = json["data"] as? [[String: Any]] {
            return dataArray.count
        }
        throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
    }
    
    func fetchUserProfile() async throws -> ProfileDetails {
        var components = URLComponents(string: "https://api.myanimelist.net/v2/users/@me")!
        components.queryItems = [
            URLQueryItem(name: "fields", value: "id,name,picture,gender,birthday,location,joined_at,time_zone,anime_statistics,manga_statistics")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let request = buildRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ProfileDetails.self, from: data)
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
