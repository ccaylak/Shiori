import SwiftUI
import AlertToast

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @StateObject private var alertManager: AlertManager = .shared   // ← hier
    private var tokenHandler: TokenHandler = .shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(alertManager)
                .toast(isPresenting: $alertManager.isLoading, tapToDismiss: false) {
                    AlertToast(type: .loading, title: String(localized: "Loading..."))
                }
                .toast(isPresenting: $alertManager.showAddedAlert) {
                    AlertToast(displayMode: .hud, type: .systemImage("book.circle", .accentColor), title: String(localized: "Added to library"))
                }
                .toast(isPresenting: $alertManager.showRemovedAlert) {
                    AlertToast(displayMode: .hud, type: .systemImage("x.circle", .red), title: String(localized: "Removed from library"))
                }
                .toast(isPresenting: $alertManager.showUpdatedAlert) {
                    AlertToast(displayMode: .hud, type: .systemImage("arrow.trianglehead.2.clockwise.rotate.90.circle", .accentColor), title: String(localized: "Progress updated"))
                }
                .onAppear {
                    if isFirstLaunch {
                        tokenHandler.revokeTokens()
                        isFirstLaunch = false
                    }
                }
        }
    }
}
