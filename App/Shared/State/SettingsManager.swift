import SwiftUI

@MainActor final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("appearance") var appearance = Appearance.system
    @AppStorage("accentColor") var accentColor = AccentColor.red
    @AppStorage("nsfw") var showNsfwContent = false
    @AppStorage("titleLanguage") var titleLanguage = TitleLanguage.english
    @AppStorage("airingSoon") var showAiringSoonBanner = true
    @AppStorage("mangaFormat") var mangaFormat = MangaFormat.both
    @AppStorage("animeFormat") var animeFormat = AnimeFormat.episode
    @AppStorage("nameFormat") var nameFormat = NameFormat.firstLast
    @AppStorage("includeFirstEpisodeInDuration") var includeFirstEpisodeInDuration = true
    @AppStorage("advancedMode") var advancedMode: Bool = false
    
    private init() {}
}
