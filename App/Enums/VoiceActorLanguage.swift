import Foundation

enum VoiceActorLanguage: String, CaseIterable, Comparable, Hashable {
    case japanese, english, german, french, spanish, italian, chinese, korean, unknown
    
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
        }
    }
    
    static func < (lhs: VoiceActorLanguage, rhs: VoiceActorLanguage) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
}
