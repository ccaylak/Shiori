import SwiftUI

@MainActor final class SectionsManager: ObservableObject {
    static let shared = SectionsManager()
    
    @AppStorage("sections.progress") var showProgress = false
    @AppStorage("sections.general") var showGeneral = false
    @AppStorage("sections.genres") var showGenres = false
    @AppStorage("sections.score") var showScore = false
    @AppStorage("sections.related") var showRelated = false
    @AppStorage("sections.recommendations") var showRecommendations = false
    @AppStorage("sections.characters") var showCharacters = false
    
    private init() {}
}
