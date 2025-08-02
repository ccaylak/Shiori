import Foundation
import SwiftUI

enum SupportedLanguages: String, CaseIterable {
    case german, english, portuguese
    
    var displayName: String {
        switch self {
        case .german: String(localized: "🇩🇪 German", comment: "Supported language")
        case .english: String(localized: "🇬🇧 English", comment: "Supported language")
        case .portuguese: String(localized: "🇵🇹 Portuguese", comment: "Supported language")
        }
    }
    
    @ViewBuilder
    var additionalInfoView: some View {
        if self == .portuguese {
            Link("By Alex Madeira", destination: URL(string: "https://alexandremadeira.dev")!)
                .font(.caption)
        } else {
            EmptyView()
        }
    }
}
