import Foundation
import Observation

@MainActor
@Observable
final class LibrarySettings {
    private enum Key {
        static let mediaType = "libraryMediaType"

        static let animeSortOrder = "animeSortOrder"
        static let animeProgressStatus = "animeProgressStatus"

        static let mangaSortOrder = "mangaSortOrder"
        static let mangaProgressStatus = "mangaProgressStatus"

        static let sortDirection = "sortDirection"
    }

    private let defaults: UserDefaults

    var mediaType: SeriesType {
        didSet {
            defaults.set(mediaType.rawValue, forKey: Key.mediaType)

            settingsChanged()
        }
    }

    var animeSortOrder: MediaSort.AnimeSort {
        didSet {
            defaults.set(animeSortOrder.rawValue, forKey: Key.animeSortOrder)

            settingsChanged()
        }
    }

    var animeProgressStatus: ProgressStatus.Anime {
        didSet {
            defaults.set(animeProgressStatus.rawValue, forKey: Key.animeProgressStatus)

            settingsChanged()
        }
    }

    var mangaSortOrder: MediaSort.MangaSort {
        didSet {
            defaults.set(mangaSortOrder.rawValue, forKey: Key.mangaSortOrder)

            settingsChanged()
        }
    }

    var mangaProgressStatus: ProgressStatus.Manga {
        didSet {
            defaults.set(mangaProgressStatus.rawValue, forKey: Key.mangaProgressStatus)

            settingsChanged()
        }
    }

    var sortDirection: SortDirection {
        didSet {
            defaults.set(sortDirection.rawValue, forKey: Key.sortDirection)

            settingsChanged()
        }
    }

    private(set) var needToLoadData = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        mediaType = defaults.enumValue(
            forKey: Key.mediaType,
            default: .manga
        )

        animeSortOrder = defaults.enumValue(
            forKey: Key.animeSortOrder,
            default: .listUpdatedAt
        )

        animeProgressStatus = defaults.enumValue(
            forKey: Key.animeProgressStatus,
            default: .completed
        )

        mangaSortOrder = defaults.enumValue(
            forKey: Key.mangaSortOrder,
            default: .listUpdatedAt
        )

        mangaProgressStatus = defaults.enumValue(
            forKey: Key.mangaProgressStatus,
            default: .completed
        )

        sortDirection = defaults.enumValue(
            forKey: Key.sortDirection,
            default: .descending
        )
    }

    private func settingsChanged() {
        needToLoadData.toggle()
    }
}
