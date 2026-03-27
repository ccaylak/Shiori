import Foundation
import SwiftUI

enum SupportedLanguages: String, CaseIterable {
    case german, english
    
    var displayName: String {
        switch self {
        case .german: String(localized: "🇩🇪 German", comment: "Supported language")
        case .english: String(localized: "🇬🇧 English", comment: "Supported language")
        }
    }
}
