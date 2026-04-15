import SwiftUI

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
                
                Section("General") {
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
                    
                    HStack {
                        Label("Show NSFW Content", systemImage: "eye.trianglebadge.exclamationmark")
                        Spacer()
                        Button {
                            settingsManager.showNsfwContent.toggle()
                        }label: {
                            ZStack(alignment: .centerFirstTextBaseline) {
                                Image(systemName: "eye.slash")
                                    .hidden()
                                    .imageScale(.large)
                                Image(systemName: settingsManager.showNsfwContent ? "eye" : "eye.slash")
                                    .contentTransition(.symbolEffect(.replace))
                                    .imageScale(.large)
                            }
                            .foregroundColor(.accentColor)
                            .symbolRenderingMode(.hierarchical)
                        }
                        .sensoryFeedback(.selection, trigger: settingsManager.showNsfwContent)
                        .buttonStyle(.borderless)
                    }
                    
                    NavigationLink {
                        NameSelectionView()
                    } label: {
                        Label {
                            VStack (alignment: .leading, spacing: 2) {
                                Text("Names")
                                    .font(.headline)
                                
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
                                    .font(.headline)
                                
                                Text("Preferred title language for Anime and Manga")
                                    .font(.caption)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "globe")
                        }
                    }
                }
                
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
                                    .font(.headline)
                                
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
                
                Section ("Contact"){
                    Link(destination: URL(string: "mailto:shiori.app@icloud.com")!) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mail")
                                    .font(.headline)
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
                                Text("Discord")
                                    .font(.headline)
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
                Link("MyAnimeList", destination: URL(string: "https://MyAnimeList.net")!)
                Link("Jikan", destination: URL(string: "https://jikan.moe")!)
            }
            
            Section ("Third-Party Libraries") {
                Link("AlertToast", destination: URL(string: "https://github.com/elai950/AlertToast")!)
                Link("KeychainSwift", destination: URL(string: "https://github.com/evgenyneu/keychain-swift")!)
                Link("Nuke", destination: URL(string: "https://github.com/kean/Nuke")!)
                Link("TelemetryDeck", destination: URL(string: "https://telemetrydeck.com")!)
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

