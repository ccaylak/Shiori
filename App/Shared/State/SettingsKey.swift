import Foundation

enum SettingsKey: String, CaseIterable, Sendable {
    case appearance
    case accentColor
    case nsfw
    case titleLanguage
    case mangaFormat
    case animeFormat
    case nameFormat
    case includeFirstEpisodeInDuration
    case advancedMode

    case isExtendedDataEnabled
    case extendedDataSource

    case airingNotificationsEnabled = "airingNotifications.enabled"
    case airingNotificationTiming = "airingNotifications.timing"
    case airingNotificationTimeFormat = "airingNotifications.timeFormat"
}
