import Foundation

struct Config {
    private static let values: [String: Any] = {
        guard
            let path = Bundle.main.path(
                forResource: "secrets",
                ofType: "json"
            ),
            let data = try? Data(
                contentsOf: URL(fileURLWithPath: path),
                options: .mappedIfSafe
            ),
            let json = try? JSONSerialization.jsonObject(
                with: data
            ) as? [String: Any]
        else {
            preconditionFailure("Could not load secrets.json")
        }

        return json
    }()

    static var malKey: String {
        guard let value = values["MAL_KEY"] as? String else {
            preconditionFailure("MAL_KEY is missing")
        }

        return value
    }

    static var aniListClientID: String {
        guard let value = values["ANILIST_CLIENT_ID"] as? String else {
            preconditionFailure("ANILIST_CLIENT_ID is missing")
        }

        return value
    }

    static var telemetryDeck: String {
        guard let value = values["TELEMETRY_DECK"] as? String else {
            preconditionFailure("TELEMETRY_DECK is missing")
        }

        return value
    }
}
