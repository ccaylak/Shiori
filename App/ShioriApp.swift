import SwiftUI
import AlertToast
import TelemetryDeck

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("showDiscordSheet") private var showDiscordSheet: Bool = true
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @StateObject private var alertManager: AlertManager = .shared   // ← hier
    private var tokenHandler: TokenHandler = .shared
    
    init() {
        TelemetryDeck.initialize(config: .init(appID: Config.telemetryDeck))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .sheet(isPresented: $showDiscordSheet) {
                    VStack(spacing: 20) {
                        HStack {
                            Image("discord_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(red: 88/255, green: 101/255, blue: 242/255))
                            
                            Text("Discord")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 88/255, green: 101/255, blue: 242/255))
                        }
                        
                        
                        Text("Get the latest app news, explore the roadmap, share feature ideas, report bugs, or just hang out – all on Discord!")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .frame(maxWidth: 400)
                        
                        Button("Join Server") {
                            if let url = URL(string: "https://discord.gg/4ajqv3aMdd") {
                                UIApplication.shared.open(url)
                            }
                            showDiscordSheet.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 88/255, green: 101/255, blue: 242/255))
                        .controlSize(.regular)
                        .frame(maxWidth: 150)

                        Button("No Thanks", role: .destructive) {
                            showDiscordSheet.toggle()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                        .frame(maxWidth: 150)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .presentationDetents([.fraction(0.4)])
                    .interactiveDismissDisabled()
                    .presentationBackgroundInteraction(.disabled)
                    .presentationDragIndicator(.visible)
                    .ignoresSafeArea(edges: .top)
                }
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
