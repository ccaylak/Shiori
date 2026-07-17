import Foundation

enum JikanResponseValidator {
    
    static func validate(
        data: Data,
        response: URLResponse,
        api: APIService,
        endpoint: String
    ) throws {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return
        }
        
        guard !(200...299).contains(statusCode) else {
            return
        }
        
        let jikanError = try? JSONDecoder
            .snakeCaseDecoder
            .decode(JikanErrorResponse.self, from: data)
        
        Metrics.badStatusCode(
            api: api,
            httpStatusCode: statusCode,
            endpoint: endpoint,
        )
        
        throw JikanAPIError.badStatusCode(
            statusCode: statusCode,
            response: jikanError
        )
    }
}
