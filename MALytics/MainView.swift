import SwiftUI

struct MainView: View {
    
    @AppStorage("tab") private var initialTab = "search"
    @AppStorage("appearance") private var appearance: String = "system"
    @AppStorage("accentColor") private var accentColor = "blue"
    
    var body: some View {
        TabView(selection: $initialTab) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag("search")
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag("settings")
        }
        .preferredColorScheme(ColorScheme.getByColorSchemeString(appearance))
        .accentColor(Color.getByColorString(accentColor))
    }
}

#Preview {
    MainView()
}
