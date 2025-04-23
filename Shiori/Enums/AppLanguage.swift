import Foundation

enum AppLanguage: String, CaseIterable {
    case english, german
    
    var displayName: String {
        switch self {
        case .english: String(localized: "English")
        case .german: String(localized: "German")
        }
    }
}
