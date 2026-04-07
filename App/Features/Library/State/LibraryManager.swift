import SwiftUI

@MainActor final class LibraryManager: ObservableObject {
    static let shared = LibraryManager()
    
    @AppStorage("libraryMediaType") var mediaType = SeriesType.manga {
        didSet {
            settingsChanged()
        }
    }
    
    @AppStorage("animeSortOrder") var animeSortOrder: MediaSort.AnimeSort = .listUpdatedAt {
        didSet {
            settingsChanged()
        }
    }
    @AppStorage("animeProgressStatus") var animeProgressStatus: ProgressStatus.Anime = .completed {
        didSet {
            settingsChanged()
        }
    }
    
    @AppStorage("mangaSortOrder") var mangaSortOrder: MediaSort.MangaSort = .listUpdatedAt {
        didSet {
            settingsChanged()
        }
    }
    @AppStorage("mangaProgressStatus") var mangaProgressStatus: ProgressStatus.Manga = .completed {
        didSet {
            settingsChanged()
        }
    }
    
    @AppStorage("sortDirection") var sortDirection: SortDirection = .descending {
        didSet {
            settingsChanged()
        }
    }
    
    @Published var needToLoadData = false
    
    private init() {}
    
    private func settingsChanged() {
        needToLoadData.toggle()
    }
}
