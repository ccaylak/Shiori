import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = "search"
    @AppStorage("appearance") private var appearance = Appearance.system
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
        .preferredColorScheme(ColorScheme.getByColorSchemeString(appearance.rawValue))
        .accentColor(Color.getByColorString(accentColor.rawValue))
    }
}

#Preview {
    MainView()
}
