import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @StateObject private var settingsManager: SettingsManager = .shared
    
    private var tokenHandler: TokenHandler = .shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section("App Info") {
                    NavigationLink(destination: AboutView()) {
                        Label("About Shiori", systemImage: "info.circle")
                    }
                }
                
                Section("Preferences") {
                    Picker("Appearance", systemImage: "circle.lefthalf.filled", selection: $settingsManager.appearance) {
                        ForEach(Appearance.allCases, id: \.self) { appearance in
                            Text(appearance.displayName).tag(appearance)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Accent Color", systemImage: "paintpalette", selection: $settingsManager.accentColor) {
                        ForEach(AccentColor.allCases, id: \.self) { accentColor in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.getByColorString(accentColor.rawValue))
                                Text(accentColor.displayName)
                            }.tag(accentColor)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Content") {
                    Toggle(isOn: $settingsManager.showNsfwContent) {
                        Label("Show NSFW Content", systemImage: "eye.trianglebadge.exclamationmark")
                    }
                    .toggleStyle(.switch)
                }
                
                Section("Display & Language") {
                    NavigationLink {
                        NameSelectionView()
                    } label: {
                        Label {
                            VStack (alignment: .leading, spacing: 2) {
                                Text("Names")
                                
                                Text("Choose how names are displayed")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "textformat.characters.arrow.left.and.right")
                        }
                    }
                    
                    NavigationLink {
                        TitleLanguageSelectionView()
                    } label: {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Title Language")
                                
                                Text("Preferred title language for Anime and Manga")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "globe")
                        }
                    }
                    
                    Toggle(isOn: $settingsManager.isExtendedDataEnabled) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Extended Data")
                                
                                Text("Additional data for anime, manga, characters and people.")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "curlybraces")
                        }
                    }
                    .toggleStyle(.switch)
                    
                    if settingsManager.isExtendedDataEnabled {
                        Picker(
                            "API",
                            systemImage: "chevron.left.forwardslash.chevron.right",
                            selection: $settingsManager.extendedDataSource
                        ) {
                            ForEach([APIService.jikan, .tenrai], id: \.self) { entry in
                                Text(entry.displayName)
                                    .tag(entry)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                }
                
                if tokenHandler.isAuthenticated {
                    Section("Library") {
                        NavigationLink {
                            MangaProgressFormatSelectionView()
                        } label: {
                            Label("Manga Tracking", systemImage: SeriesType.manga.icon)
                        }
                        
                        NavigationLink {
                            AnimeFormatSelectionView()
                        } label: {
                            Label("Anime Tracking", systemImage: SeriesType.anime.icon)
                        }
                        
                        Toggle(isOn: $settingsManager.advancedMode) {
                            Label {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Advanced Mode")
                                    
                                    Text("Adds additional fields for tracking")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            } icon: {
                                Image(systemName: "gearshape.2")
                            }
                        }
                        .toggleStyle(.switch)
                    }
                    
                    Section {
                        NavigationLink {
                            NotificationSettingsView()
                        } label: {
                            Label("Notifications", systemImage: "bell")
                        }
                    }
                }
                
                Section ("Contact"){
                    Link(destination: URL(string: "mailto:shiori.app@icloud.com")!) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mail")
                                    .foregroundStyle(Color.primary)
                                
                                Text("Feedback and Support")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "envelope")
                        }
                    }
                    Link(destination: URL(string: "https://discord.gg/4ajqv3aMdd")!) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(verbatim: "Discord")
                                    .foregroundStyle(Color.primary)
                                
                                Text("Updates and More")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image("discord_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                if tokenHandler.isAuthenticated {
                    Section {
                        Button(role: .destructive) {
                            if let url = URL(string: "https://myanimelist.net/account_deletion") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("Delete MyAnimeList Account", systemImage: "trash")
                        }
                    } footer: {
                        Text("You’ll be redirected to MyAnimeList.net to complete the deletion.")
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

private struct AboutView: View {
    var body: some View {
        Form {
            VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        Image(uiImage: UIImage(named: "AppIcon")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(12)
                            .strokedBorder()
                        
                        Text("Icon made by Nicole Knutas")
                            .font(.caption)
                            .bold()
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .padding(.bottom, -30)
            
            Section {
                LabeledContent("App Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
                LabeledContent("Build Number", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")
            }
            
            Section ("Third-Party Services") {
                ForEach(APIService.allCases, id: \.self) { api in
                    if let url = URL(string: api.website) {
                        Link(destination: url) {
                            Text(api.displayName)
                        }
                    }
                }
            }
            
            Section ("Third-Party Libraries") {
                Link(destination: URL(string: "https://github.com/evgenyneu/keychain-swift")!) {
                    Text(verbatim: "KeychainSwift")
                }
                Link(destination: URL(string: "https://github.com/kean/Nuke")!) {
                    Text(verbatim: "Nuke")
                }
                Link(destination: URL(string: "https://telemetrydeck.com")!) {
                    Text(verbatim: "TelemetryDeck")
                }
            }
        }
        .noScrollEdgeEffect()
        .contentMargins(.top, -30)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("About Shiori")
    }
}

#Preview {
    SettingsView()
}

