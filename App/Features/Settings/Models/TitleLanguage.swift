import Foundation

enum TitleLanguage: String, CaseIterable {
    case japanese, romanji, english
    
    var displayName: String {
        switch self {
        case .japanese: return String(localized: "Original")
        case .romanji: return String(localized: "Romanji")
        case .english: return String(localized: "English")
        }
    }
}
