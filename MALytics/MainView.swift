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
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "book")
                }
                .tag("library")
            LoginView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag("login")
        }
        .preferredColorScheme(ColorScheme.getByColorSchemeString(appearance.rawValue))
        .accentColor(Color.getByColorString(accentColor.rawValue))
    }
}

#Preview {
    MainView()
}
