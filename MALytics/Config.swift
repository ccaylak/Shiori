import Foundation

struct Config {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["API_KEY"] as? String else {
            fatalError("Config.plist file is missing or MAL_API_KEY is not set")
        }
        return key
    }
}
