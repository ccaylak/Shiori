import Foundation

@MainActor
public class JikanPersonController {
    
    func fetchPersonFull(id: Int, apiService: APIService) async throws -> JikanPerson {
        let url = JikanEndpoints.Person.full(id: id, apiService: apiService)
        let request = APIRequest.buildRequest(url: url, httpMethod: .get)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try JikanResponseValidator.validate(
                data: data,
                response: response,
                api: .jikan,
                endpoint: "person.details"
        )
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanPerson.self, from: data)
    }
}
