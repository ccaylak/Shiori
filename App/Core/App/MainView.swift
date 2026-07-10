import SwiftUI
import TelemetryDeck

struct MainView: View {
    
    @AppStorage("selectedTab") private var selectedTab = "search"
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            SearchView()
                .trackNavigation(path: "search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag("search")
            SeasonView()
                .trackNavigation(path: "season")
                .tabItem {
                    Label("Season", systemImage: Season.current.icon)
                }
                .tag("season")
            LibraryView()
                .trackNavigation(path: "library")
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag("library")
            LoginView()
                .trackNavigation(path: "login")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag("login")
        }
        .preferredColorScheme(ColorScheme.getByColorSchemeString(settingsManager.appearance.rawValue))
        .accentColor(Color.getByColorString(settingsManager.accentColor.rawValue))
    }
}

#Preview {
    MainView()
}
