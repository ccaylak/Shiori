import Foundation

@MainActor class JikanRelationsController {
    func fetchAnimeRelations(id: Int) async throws -> [RelationEntry] {
        let url = URL(string: JikanEndpoints.Relations(id: id).animeRelations)!
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "anime.relations"
        )
        
        let animeRelations = try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanRelations.self, from: data)
        
        return animeRelations.data
                    .filter { $0.relation == "Adaptation" }
                    .flatMap { $0.entry }
    }
    
    func fetchMangaRelations(id: Int) async throws -> [RelationEntry] {
        let url = URL(string: JikanEndpoints.Relations(id: id).mangaRelations)!
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "manga.relations"
        )
        
        let mangaRelations = try JSONDecoder
            .snakeCaseDecoder
            .decode(JikanRelations.self, from: data)
        
        return mangaRelations.data
                    .filter { $0.relation == "Adaptation" }
                    .flatMap { $0.entry }
    }
}
