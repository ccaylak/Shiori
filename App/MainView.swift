import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = "search"
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag("search")
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag("library")
            LoginView()
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
