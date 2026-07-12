struct JikanErrorResponse: Decodable {
    let status: Int?
    let type: String?
    let message: String?
    let error: String?
    let reportUrl: String?
}

enum JikanAPIError: Error {
    case badStatusCode(statusCode: Int, response: JikanErrorResponse?)
}
