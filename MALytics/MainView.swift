import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    @AppStorage("appAppereance") private var appAppereance: String = "system"
    @AppStorage("accentColor") private var accentColor = "blue"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .preferredColorScheme(colorScheme(from: appAppereance))
        .accentColor(accentColor(from: accentColor))
    }
    
    private func colorScheme(from appearance: String) -> ColorScheme? {
        switch appearance {
        case "dark":
            return .dark
        case "light":
            return .light
        default:
            return nil // Systemvorgabe
        }
    }
    
    private func accentColor(from accent: String) -> Color {
        switch accent {
            case "blue":
            return .blue
        case "red":
            return .red
        default:
            return .primary
        }
    }
}

#Preview {
    MainView()
}
