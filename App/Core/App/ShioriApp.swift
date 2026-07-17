import SwiftUI
import TelemetryDeck

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch")
    private var isFirstLaunch: Bool = true
    
    @AppStorage("shouldShowOnboarding")
    private var shouldShowOnboarding: Bool = false
    
    @ObservedObject
    private var settingsManager: SettingsManager = .shared
    
    @StateObject
    private var toastManager: ToastManager = .shared
    
    private var tokenHandler: TokenHandler = .shared
    private let notificationDelegate = NotificationDelegate()
    
    init() {
        TelemetryDeck.initialize(
            config: .init(appID: Config.telemetryDeck)
        )
        
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .sheet(isPresented: $shouldShowOnboarding) {
                    OnboardingFlowView(
                        isPresented: $shouldShowOnboarding
                    )
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(.disabled)
                    .interactiveDismissDisabled()
                }
                .environmentObject(toastManager)
                
                .toast(
                    isPresenting: $toastManager.isLoading,
                    tapToDismiss: false
                ) {
                    GlassToast(
                        type: .loading,
                        title: String(localized: "Loading...")
                    )
                }
                
                .toast(
                    isPresenting: $toastManager.showAddedToast
                ) {
                    GlassToast(
                        displayMode: .hud,
                        type: .systemImage(
                            "book.circle",
                            .accentColor
                        ),
                        title: String(
                            localized: "Added to library"
                        )
                    )
                }
                
                .toast(
                    isPresenting: $toastManager.showRemovedToast
                ) {
                    GlassToast(
                        displayMode: .hud,
                        type: .systemImage(
                            "x.circle",
                            .red
                        ),
                        title: String(
                            localized: "Removed from library"
                        )
                    )
                }
                
                .toast(
                    isPresenting: $toastManager.showUpdatedToast
                ) {
                    GlassToast(
                        displayMode: .hud,
                        type: .systemImage(
                            "arrow.trianglehead.2.clockwise.rotate.90.circle",
                            .accentColor
                        ),
                        title: String(
                            localized: "Progress updated"
                        )
                    )
                }
                
                .onAppear {
                    if isFirstLaunch {
                        tokenHandler.revokeTokens()
                        shouldShowOnboarding = true
                        isFirstLaunch = false
                    }
                }
        }
        .modelContainer(for: AnimeSchedule.self)
    }
}
