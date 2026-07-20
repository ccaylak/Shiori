import Foundation
import Observation

@MainActor
@Observable
final class ResultSettings {
    private enum Key {
        static let seriesType = "mediaType"
        static let animeRankingType = "animeRankingType"
        static let mangaRankingType = "mangaRankingType"
        static let animeStudioSort = "animeStudioSort"
        static let animeStudioOption = "animeStudioOption"
    }

    private let defaults: UserDefaults

    var seriesType: SeriesType {
        didSet {
            defaults.set(
                seriesType.rawValue,
                forKey: Key.seriesType
            )

            settingsChanged()
        }
    }

    var animeRankingType: SortType.Anime {
        didSet {
            defaults.set(
                animeRankingType.rawValue,
                forKey: Key.animeRankingType
            )

            settingsChanged()
        }
    }

    var mangaRankingType: SortType.Manga {
        didSet {
            defaults.set(
                mangaRankingType.rawValue,
                forKey: Key.mangaRankingType
            )

            settingsChanged()
        }
    }

    var animeStudioSort: SortDirection {
        didSet {
            defaults.set(
                animeStudioSort.rawValue,
                forKey: Key.animeStudioSort
            )

            settingsChanged()
        }
    }

    var animeStudioOption: StudioSortOption {
        didSet {
            defaults.set(
                animeStudioOption.rawValue,
                forKey: Key.animeStudioOption
            )

            settingsChanged()
        }
    }

    private(set) var needsToLoadData = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        seriesType = defaults.enumValue(
            forKey: Key.seriesType,
            default: .manga
        )

        animeRankingType = defaults.enumValue(
            forKey: Key.animeRankingType,
            default: .all
        )

        mangaRankingType = defaults.enumValue(
            forKey: Key.mangaRankingType,
            default: .all
        )

        animeStudioSort = defaults.enumValue(
            forKey: Key.animeStudioSort,
            default: .descending
        )

        animeStudioOption = defaults.enumValue(
            forKey: Key.animeStudioOption,
            default: .favorites
        )
    }

    private func settingsChanged() {
        needsToLoadData.toggle()
    }
}
