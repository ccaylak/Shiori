import SwiftUI

@MainActor final class ResultManager: ObservableObject {
    static let shared = ResultManager()
    
    @AppStorage("mediaType") var seriesType = SeriesType.manga {
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
    
    @AppStorage("animeStudioSort") var animeStudioSort = SortDirection.descending {
        didSet {
            settingsChanged()
        }
    }
    
    @AppStorage("animeStudioOption") var animeStudioOption = StudioSortOption.favorites {
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
