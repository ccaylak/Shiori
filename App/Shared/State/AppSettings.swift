import Foundation
import Observation

@MainActor
@Observable
final class AppSettings {
    private enum Key {
        static let appearance = "appearance"
        static let accentColor = "accentColor"
        static let nsfw = "nsfw"
        static let titleLanguage = "titleLanguage"
        static let mangaFormat = "mangaFormat"
        static let animeFormat = "animeFormat"
        static let nameFormat = "nameFormat"
        static let includeFirstEpisodeInDuration = "includeFirstEpisodeInDuration"
        static let advancedMode = "advancedMode"

        static let isExtendedDataEnabled = "isExtendedDataEnabled"
        static let extendedDataSource = "extendedDataSource"

        static let airingNotificationsEnabled = "airingNotifications.enabled"
        static let airingNotificationTiming = "airingNotifications.timing"
        static let airingNotificationTimeFormat = "airingNotifications.timeFormat"
    }

    private let defaults: UserDefaults

    var appearance: Appearance {
        didSet {
            defaults.set(appearance.rawValue, forKey: Key.appearance)
        }
    }

    var accentColor: AccentColor {
        didSet {
            defaults.set(accentColor.rawValue, forKey: Key.accentColor)
        }
    }

    var showNsfwContent: Bool {
        didSet {
            defaults.set(showNsfwContent, forKey: Key.nsfw)
        }
    }

    var titleLanguage: TitleLanguage {
        didSet {
            defaults.set(titleLanguage.rawValue, forKey: Key.titleLanguage)
        }
    }

    var mangaFormat: MangaFormat {
        didSet {
            defaults.set(mangaFormat.rawValue, forKey: Key.mangaFormat)
        }
    }

    var animeFormat: AnimeFormat {
        didSet {
            defaults.set(animeFormat.rawValue, forKey: Key.animeFormat)
        }
    }

    var nameFormat: NameFormat {
        didSet {
            defaults.set(nameFormat.rawValue, forKey: Key.nameFormat)
        }
    }

    var includeFirstEpisodeInDuration: Bool {
        didSet {
            defaults.set(
                includeFirstEpisodeInDuration,
                forKey: Key.includeFirstEpisodeInDuration
            )
        }
    }

    var advancedMode: Bool {
        didSet {
            defaults.set(advancedMode, forKey: Key.advancedMode)
        }
    }

    var isExtendedDataEnabled: Bool {
        didSet {
            defaults.set(
                isExtendedDataEnabled,
                forKey: Key.isExtendedDataEnabled
            )
        }
    }

    var extendedDataSource: APIService {
        didSet {
            defaults.set(
                extendedDataSource.rawValue,
                forKey: Key.extendedDataSource
            )
        }
    }

    var airingNotificationsEnabled: Bool {
        didSet {
            defaults.set(
                airingNotificationsEnabled,
                forKey: Key.airingNotificationsEnabled
            )
        }
    }

    var airingNotificationTiming: AiringNotificationTiming {
        didSet {
            defaults.set(
                airingNotificationTiming.rawValue,
                forKey: Key.airingNotificationTiming
            )
        }
    }

    var airingNotificationTimeFormat: AiringTimeFormat {
        didSet {
            defaults.set(
                airingNotificationTimeFormat.rawValue,
                forKey: Key.airingNotificationTimeFormat
            )
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        appearance = defaults.enumValue(
            forKey: Key.appearance,
            default: .system
        )

        accentColor = defaults.enumValue(
            forKey: Key.accentColor,
            default: .red
        )

        showNsfwContent = defaults.boolValue(
            forKey: Key.nsfw,
            default: true
        )

        titleLanguage = defaults.enumValue(
            forKey: Key.titleLanguage,
            default: .english
        )

        mangaFormat = defaults.enumValue(
            forKey: Key.mangaFormat,
            default: .chapter
        )

        animeFormat = defaults.enumValue(
            forKey: Key.animeFormat,
            default: .episode
        )

        nameFormat = defaults.enumValue(
            forKey: Key.nameFormat,
            default: .firstLast
        )

        includeFirstEpisodeInDuration = defaults.boolValue(
            forKey: Key.includeFirstEpisodeInDuration,
            default: true
        )

        advancedMode = defaults.boolValue(
            forKey: Key.advancedMode,
            default: false
        )

        isExtendedDataEnabled = defaults.boolValue(
            forKey: Key.isExtendedDataEnabled,
            default: true
        )

        extendedDataSource = defaults.enumValue(
            forKey: Key.extendedDataSource,
            default: .tenrai
        )

        airingNotificationsEnabled = defaults.boolValue(
            forKey: Key.airingNotificationsEnabled,
            default: false
        )

        airingNotificationTiming = defaults.enumValue(
            forKey: Key.airingNotificationTiming,
            default: .airing
        )

        airingNotificationTimeFormat = defaults.enumValue(
            forKey: Key.airingNotificationTimeFormat,
            default: .twentyFourHour
        )
    }
}
