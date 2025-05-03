import Foundation

struct Config {
    private static func secrets() -> [String: Any] {
            let fileName = "secrets"
            let path = Bundle.main.path(forResource: fileName, ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        }
    
    static var apiKey: String {
        return secrets()["API_KEY"] as! String
    }
}
