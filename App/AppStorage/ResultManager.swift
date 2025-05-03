import SwiftUI

@MainActor final class ResultManager: ObservableObject {
    static let shared = ResultManager()
    
    @AppStorage("mediaType") var mediaType = MediaType.manga {
        didSet {
            settingsChanged()
        }
    }
    @AppStorage("animeRankingType") var animeRankingType = SortType.Anime.all {
        didSet {
            settingsChanged()
        }
    }
    @AppStorage("mangaRankingType") var mangaRankingType = SortType.Manga.all {
        didSet {
            settingsChanged()
        }
    }
    
    @Published var needsToLoadData = false
    
    private init() {}
    
    private func settingsChanged() {
        needsToLoadData.toggle()
    }
}
