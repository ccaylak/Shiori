import Foundation
import SwiftUI

enum EditSections: String, CaseIterable, Hashable {
    
    case general, genres, score, related, recommendations, characters
    
    @MainActor
    var toggleComponent: some View {
        switch self {
        case .general:
            Toggle("General", isOn: SectionsManager.shared.$showGeneral)
                .toggleStyle(.switch)
        case .genres:
            Toggle("Genres", isOn: SectionsManager.shared.$showGenres)
                .toggleStyle(.switch)
        case .score:
            Toggle("Score", isOn: SectionsManager.shared.$showScore)
                .toggleStyle(.switch)
        case .related:
            Toggle("Related", isOn: SectionsManager.shared.$showRelated)
                .toggleStyle(.switch)
        case .recommendations:
            Toggle("Recommendations", isOn: SectionsManager.shared.$showRecommendations)
                .toggleStyle(.switch)
        case .characters:
            Toggle("Characters", isOn: SectionsManager.shared.$showCharacters)
                .toggleStyle(.switch)
        }
    }
}
