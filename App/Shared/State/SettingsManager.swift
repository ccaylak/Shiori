import SwiftUI

@MainActor final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("appearance") var appearance = Appearance.system
    @AppStorage("accentColor") var accentColor = AccentColor.red
    @AppStorage("nsfw") var showNsfwContent = true
    @AppStorage("titleLanguage") var titleLanguage = TitleLanguage.english
    @AppStorage("mangaFormat") var mangaFormat = MangaFormat.chapter
    @AppStorage("animeFormat") var animeFormat = AnimeFormat.episode
    @AppStorage("nameFormat") var nameFormat = NameFormat.firstLast
    @AppStorage("includeFirstEpisodeInDuration") var includeFirstEpisodeInDuration = true
    @AppStorage("advancedMode") var advancedMode: Bool = false
    
    @AppStorage("isExtendedDataEnabled") var isExtendedDataEnabled: Bool = true
    @AppStorage("extendedDataSource") var extendedDataSource: APIService = .tenrai
    
    @AppStorage("airingNotifications.enabled") var airingNotificationsEnabled = false
    @AppStorage("airingNotifications.timing") var airingNotificationTiming: AiringNotificationTiming = .airing
    @AppStorage("airingNotifications.timeFormat") var airingNotificationTimeFormat: AiringTimeFormat = AiringTimeFormat.twentyFourHour
    
    private init() {}
}
