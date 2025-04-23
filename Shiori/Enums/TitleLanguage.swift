import Foundation

enum TitleLanguage: String, CaseIterable {
    case romanji, english, japanese
    
    var displayName: String {
        switch self {
        case .romanji: return String(localized: "Romanji")
        case .english: return String(localized: "English")
        case .japanese: return String(localized: "Japanese")
        }
    }
}
