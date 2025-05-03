import SwiftUI

@MainActor final class LibraryManager: ObservableObject {
    static let shared = LibraryManager()
    
    @AppStorage("libraryMediaType") var mediaType = MediaType.manga {
        didSet {
            settingsChanged()
        }
    }
    
    @AppStorage("animeSortOrder") var animeSortOrder: LibraryAnimeSort = .lastUpdated {
        didSet {
            settingsChanged()
        }
    }
    @AppStorage("animeProgressStatus") var animeProgressStatus: ProgressStatus.Anime = .completed {
        didSet {
            settingsChanged()
        }
    }
    
    @AppStorage("mangaSortOrder") var mangaSortOrder: LibraryMangaSort = .lastUpdated {
        didSet {
            settingsChanged()
        }
    }
    @AppStorage("mangaProgressStatus") var mangaProgressStatus: ProgressStatus.Manga = .completed {
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
