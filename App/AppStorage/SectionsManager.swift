import SwiftUI

@MainActor final class SectionsManager: ObservableObject {
    static let shared = SectionsManager()
    
    @AppStorage("sections.progress") var showProgress = true
    @AppStorage("sections.general") var showGeneral = true
    @AppStorage("sections.genres") var showGenres = true
    @AppStorage("sections.score") var showScore = true
    @AppStorage("sections.related") var showRelated = true
    @AppStorage("sections.recommendations") var showRecommendations = true
    @AppStorage("sections.characters") var showCharacters = true
    
    private init() {}
}
