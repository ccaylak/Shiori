import TelemetryDeck

enum Metrics {
    static func authToken(_ action: AuthTokenAction) {
        TelemetryDeck.signal(action.rawValue)
    }
    
    static func decodingFailed<T>(_ error: Error, api: String, endpoint: String, model: T.Type) {
        TelemetryDeck.errorOccurred(
            id: "API.decodingFailed",
            parameters: [
                "api": api,
                "endpoint": endpoint,
                "model": String(describing: model),
                "errorType": String(describing: type(of: error))
            ]
        )
    }
    
    static func badStatusCode(api: String, statusCode: Int, endpoint: String) {
        TelemetryDeck.errorOccurred(
            id: "API.badStatusCode",
            parameters: [
                "api": api,
                "statusCode": "\(statusCode)",
                "endpoint": endpoint
            ]
        )
    }
    
    static func entryAction(_ action: EntryAction, format: SeriesType, mediaType: MediaType) {
        TelemetryDeck.signal(
            action.rawValue,
            parameters: [
                "format": "\(format)",
                "mediaType": "\(mediaType)"
            ]
        )
    }
}

enum AuthTokenAction: String {
    case expired = "Auth.tokenExpired"
    case refreshed = "Auth.tokenRefreshed"
}

enum EntryAction: String {
    case added = "Library.mediaAdded"
    case deleted = "Library.mediaDeleted"
    case updated = "Library.mediaUpdated"
}
