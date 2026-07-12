import Foundation

@MainActor public class JikanPersonController {
    
    func fetchPersonFull(id: Int) async throws -> JikanPerson {
        let url = URL(string: JikanEndpoints.Person(id: id).full)!
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
