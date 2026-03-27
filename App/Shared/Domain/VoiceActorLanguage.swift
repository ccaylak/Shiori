import Foundation

enum VoiceActorLanguage: String, CaseIterable, Comparable, Hashable {
    case japanese = "Japanese"
    case english = "English"
    case german = "German"
    case french = "French"
    case spanish = "Spanish"
    case portuguese = "Portuguese (BR)"
    case italian = "Italian"
    case chinese = "Mandarin"
    case korean = "Korean"
    case unknown
    
    var displayName: String {
        switch self {
        case .japanese:
            return String(localized: "Japanese")
        case .english:
            return String(localized: "English")
        case .german:
            return String(localized: "German")
        case .french:
            return String(localized: "French")
        case .spanish:
            return String(localized: "Spanish")
        case .italian:
            return String(localized: "Italian")
        case .chinese:
            return String(localized: "Chinese")
        case .korean:
            return String(localized: "Korean")
        case .unknown:
            return String(localized: "Unknown")
        case .portuguese:
            return String(localized: "Portuguese (BR)")
        }
    }
    
    static func < (lhs: VoiceActorLanguage, rhs: VoiceActorLanguage) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
}
