import Foundation

@MainActor public class JikanPersonController {
    
    func fetchPersonFull(id: Int) async throws -> JikanPerson {
        let url = URL(string: JikanEndpoints.Person(id: id).full)!
        
        let request = APIRequest.buildRequest(url: url, httpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder.snakeCaseDecoder
            .decode(JikanPerson.self, from: data)
    }
}
