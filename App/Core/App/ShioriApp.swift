import SwiftUI
import TelemetryDeck

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("shouldShowOnboarding") private var shouldShowOnboarding: Bool = false
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @StateObject private var alertManager: AlertManager = .shared
    private var tokenHandler: TokenHandler = .shared
    
    init() {
        TelemetryDeck.initialize(config: .init(appID: Config.telemetryDeck))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .sheet(isPresented: $shouldShowOnboarding) {
                    OnboardingFlowView(isPresented: $shouldShowOnboarding)
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(.disabled)
                    .interactiveDismissDisabled()
                }
                .environmentObject(alertManager)
                .onAppear {
                    if isFirstLaunch {
                        tokenHandler.revokeTokens()
                        shouldShowOnboarding = true
                        isFirstLaunch = false
                    }
                }
        }
    }
}
