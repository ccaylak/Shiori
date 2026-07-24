import SwiftUI
import TelemetryDeck
import UserNotifications

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch")
    private var isFirstLaunch: Bool = true
    
    @AppStorage("shouldShowOnboarding")
    private var shouldShowOnboarding: Bool = false
    
    @State
    private var settings = AppSettings()
    
    @State
    private var toastManager = ToastManager()
    
    @State
    private var librarySettings = LibrarySettings()
    
    @State
    private var resultSettings = ResultSettings()
    
    @State
    private var seasonSettings = SeasonSettings()
    
    @State
    private var networkMonitor = NetworkMonitor()
    
    @State
    private var malDependencies: MALDependencies
    
    @State
    private var accountSession: AccountSession
    
    private let notificationDelegate = NotificationDelegate()
    
    init() {
        let malDependencies = MALDependencies()

        _malDependencies = State(
            initialValue: malDependencies
        )

        _accountSession = State(
            initialValue: AccountSession(
                malDependencies: malDependencies
            )
        )

        TelemetryDeck.initialize(
            config: .init(appID: Config.telemetryDeck)
        )

        UNUserNotificationCenter.current().delegate =
            notificationDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(malDependencies)
                .environment(accountSession)
                .environment(settings)
                .environment(toastManager)
                .environment(librarySettings)
                .environment(resultSettings)
                .environment(seasonSettings)
                .sheet(isPresented: $shouldShowOnboarding) {
                    OnboardingFlowView(
                        isPresented: $shouldShowOnboarding
                    )
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(.disabled)
                    .interactiveDismissDisabled()
                }
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
                            localized: "Added to Library"
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
                            localized: "Removed from Library"
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
                            localized: "Progress Updated"
                        )
                    )
                }
            
                .toast(
                    isPresenting: $toastManager.showNoConnectionToast
                ) {
                    GlassToast(
                        displayMode: .hud,
                        type: .systemImage(
                            "wifi.slash",
                            .red
                        ),
                        title: String(
                            localized: "No Connection"
                        )
                    )
                }
            
                .toast(
                    isPresenting: $toastManager.showWeakConnectionToast
                ) {
                    GlassToast(
                        displayMode: .hud,
                        type: .systemImage(
                            "wifi.exclamationmark",
                            .orange
                        ),
                        title: String(
                            localized: "Weak Connection"
                        )
                    )
                }
                
                .onAppear {
                    guard isFirstLaunch else {
                        return
                    }
                    
                    shouldShowOnboarding = true
                    isFirstLaunch = false
                }
            
                .onChange(of: networkMonitor.status) { oldStatus, newStatus in
                    guard oldStatus != .checking,
                          newStatus == .disconnected else {
                        return
                    }

                    toastManager.showNoConnectionToast = true
                    TelemetryDeck.signal("Network.connectionLost")
                }
                .onChange(of: networkMonitor.quality) { oldQuality, newQuality in
                    guard networkMonitor.status == .connected,
                          oldQuality != .unknown,
                          oldQuality != .weak,
                          newQuality == .weak else {
                        return
                    }

                    toastManager.showWeakConnectionToast = true
                    TelemetryDeck.signal("Network.connectionWeak")
                }
        }
        .modelContainer(for: AnimeSchedule.self)
    }
}
