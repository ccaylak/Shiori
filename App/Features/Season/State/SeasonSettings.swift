import Foundation
import Observation

@MainActor
@Observable
final class SeasonSettings {
    private enum Key {
        static let selectedYear = "season.year"
        static let selectedSeason = "season.season"
    }

    private let defaults: UserDefaults

    var selectedYear: Int {
        didSet {
            defaults.set(
                selectedYear,
                forKey: Key.selectedYear
            )
        }
    }

    var selectedSeason: Season {
        didSet {
            defaults.set(
                selectedSeason.rawValue,
                forKey: Key.selectedSeason
            )
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        selectedYear = defaults.intValue(
            forKey: Key.selectedYear,
            default: Calendar.current.component(
                .year,
                from: .now
            )
        )

        selectedSeason = defaults.enumValue(
            forKey: Key.selectedSeason,
            default: .current
        )
    }
}
