import SwiftUI

@MainActor final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("appearance") var appearance = Appearance.system
    @AppStorage("accentColor") var accentColor = AccentColor.blue
    @AppStorage("result") var resultsPerPage = 10
    @AppStorage("nsfw") var showNsfwContent = false
    @AppStorage("titleLanguage") var titleLanguage = TitleLanguage.english
    @AppStorage("airingSoon") var showAiringSoonBanner = true
    
    private init() {}
}
