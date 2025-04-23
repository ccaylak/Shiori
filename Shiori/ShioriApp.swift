import SwiftUI

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @ObservedObject private var settingsManager: SettingsManager = .shared
    private var tokenHandler: TokenHandler = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    if isFirstLaunch {
                        tokenHandler.revokeTokens()
                        isFirstLaunch = false
                    }
                }
                .environment(\.locale, .init(identifier: settingsManager.appLanguage.rawValue))
        }
    }
}
