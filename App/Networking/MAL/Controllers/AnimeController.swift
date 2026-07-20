import Foundation

@MainActor
final class AnimeController {
    
    private var malService: MALService = .shared
    
    func saveProgress(
        id: Int,
        status: String,
        score: Int,
        episodes: Int,
        comments: String,
        startDate: Date?,
        finishDate: Date?
    ) async throws {
        let url = MALEndpoints.Anime(id: id).update
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let parameters: [String: String] = [
            "status": status,
            "score": "\(score)",
            "num_watched_episodes": "\(episodes)",
            "comments": comments,
            "start_date": startDate.map { dateFormatter.string(from: $0) } ?? "",
            "finish_date": finishDate.map { dateFormatter.string(from: $0) } ?? ""
        ]
        let formBody = parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .put)
        request.httpBody = formBody.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .put)
            request.httpBody = formBody.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
    }
    
    func fetchPreviews(
        searchTerm: String,
        showNsfwContent: Bool,
        rankingType: SortType.Anime
    ) async throws -> MediaResponse {
        guard var components = URLComponents(
            url: searchTerm.isEmpty ? MALEndpoints.Anime.ranking : MALEndpoints.Anime.list,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: rankingType.rawValue),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "nsfw", value: String(showNsfwContent)),
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.alternativeTitles, .numEpisodes, .mediaType, .startSeason, .status, .myListStatus])),
            URLQueryItem(name: "q", value: searchTerm)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .get)
        
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .get)
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
        do {
            return try JSONDecoder.snakeCaseDecoder
                .decode(MediaResponse.self, from: data)
        } catch {
            Metrics.decodingFailed(error, api: APIService.mal, endpoint: url.path, model: MediaResponse.self)
            throw error
        }
    }
    
    func fetchDetails(id: Int) async throws -> MediaNode {
        guard var components = URLComponents(
            url: MALEndpoints.Anime(id: id).details,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: MALApiFields.fieldsHeader(for: [.alternativeTitles, .numEpisodes, .mediaType, .startDate, .status, .mean, .synopsis, .genres, .recommendations, .endDate, .studios, .relatedAnime, .rank, .popularity, .numScoringUsers, .numListUsers, .averageEpisodeDuration, .myListStatus, .startSeason]))
        ]
        
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .get)
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .get)
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
        
        do {
            return try JSONDecoder.snakeCaseDecoder
                .decode(MediaNode.self, from: data)
        } catch {
            Metrics.decodingFailed(error, api: APIService.mal, endpoint: url.path, model: MediaNode.self)
            throw error
        }
    }
    
    func addToWatchList(id: Int) async throws {
        guard let components = URLComponents(
            url: MALEndpoints.Anime(id: id).update,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        let parameters = ["status": ProgressStatus.Anime.planToWatch.rawValue]
        let bodyData = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .put)
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .put)
            request.httpBody = bodyData.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
    }
    
    func completeEntry(id: Int) async throws {
        guard let components = URLComponents(
            url: MALEndpoints.Anime(id: id).update,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        let parameters = ["status": ProgressStatus.Anime.completed.rawValue]
        let bodyData = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .put)
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .put)
            request.httpBody = bodyData.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
    }
    
    func increaseEpisodes(id: Int, episode: Int) async throws {
        guard let components = URLComponents(
            url: MALEndpoints.Anime(id: id).update,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        let parameters = ["num_watched_episodes": String(episode)]
        let bodyData = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .put)
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .put)
            request.httpBody = bodyData.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
        
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
    }
    
    func fetchLibrary(
        showNsfwContent: Bool,
        progressStatus: ProgressStatus.Anime,
        sortOrder: MediaSort.AnimeSort
    ) async throws -> MediaResponse {
        guard var components = URLComponents(
            url: MALEndpoints.Anime.library,
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }
        
        var queryItems: [URLQueryItem] = []
        
        if progressStatus != .all {
            queryItems.append(
                URLQueryItem(name: "status", value: progressStatus.rawValue)
            )
        }
        
        if let sort = sortOrder.apiValue {
            queryItems.append(
                URLQueryItem(name: "sort", value: sort)
            )
        }
        
        queryItems += [
            URLQueryItem(
                name: "fields",
                value: MALApiFields.fieldsHeader(
                    for: [.alternativeTitles, .startDate, .mediaType, .myListStatus, .numEpisodes, .status, .startSeason, .averageEpisodeDuration]
                )
            ),
            URLQueryItem(name: "limit", value: "1000"),
            URLQueryItem(name: "nsfw", value: String(showNsfwContent))
        ]
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .get)
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .get)
            
            (data, response) = try await URLSession.shared.data(for: request)
        }
        
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
        
        do {
            return try JSONDecoder.snakeCaseDecoder
                .decode(MediaResponse.self, from: data)
        } catch {
            Metrics.decodingFailed(error, api: APIService.mal, endpoint: url.path, model: MediaResponse.self)
            throw error
        }
    }
    
    func deleteEntry(id: Int) async throws {
        guard let url = URLComponents(
            url: MALEndpoints.Anime(id: id).update,
            resolvingAgainstBaseURL: false
        )?.url else {
            throw URLError(.badURL)
        }
        
        var request = APIRequest.buildRequest(url: url, httpMethod: .delete)
        var (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try await malService.refreshToken()
            request = APIRequest.buildRequest(url: url, httpMethod: .delete)
            
            (_, response) = try await URLSession.shared.data(for: request)
        }
        
        try APIRequest.validateResponse(response, api: APIService.mal, endpoint: url.path)
    }
}
