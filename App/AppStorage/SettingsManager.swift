import SwiftUI

@MainActor final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("appearance") var appearance = Appearance.system
    @AppStorage("accentColor") var accentColor = AccentColor.red
    @AppStorage("nsfw") var showNsfwContent = false
    @AppStorage("titleLanguage") var titleLanguage = TitleLanguage.english
    @AppStorage("airingSoon") var showAiringSoonBanner = true
    @AppStorage("mangaMode") var mangaMode = MangaMode.all
    @AppStorage("animeMode") var animeMode = AnimeMode.episodes
    @AppStorage("namePresentation") var namePresentation = NamePresentation.firstLast
    
    private init() {}
}
