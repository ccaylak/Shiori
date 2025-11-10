import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settingsManager: SettingsManager = .shared
    
    private var tokenHandler: TokenHandler = .shared
    
    @State private var showConfirmationDialog: Bool = false
    
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
                    
                    Picker("Accent color", systemImage: "paintpalette", selection: $settingsManager.accentColor) {
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
                        Label("Show mature content", systemImage: "eye.trianglebadge.exclamationmark")
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
                    
                    Picker("Name order", systemImage: "textformat.characters.arrow.left.and.right", selection: $settingsManager.namePresentation) {
                        ForEach(NamePresentation.allCases, id: \.self) { mode in
                            Text(mode.displayName)
                                .tag(mode)
                        }
                    }.pickerStyle(.navigationLink)
                }
                
                Section("Library") {
                    Picker(selection: $settingsManager.mangaMode, label: Label("Manga progress", systemImage: MediaType.manga.icon)) {
                        ForEach(MangaMode.allCases, id: \.self) { mode in
                            Text(mode.displayName)
                        }
                    }
                    
//                    Picker(selection: $settingsManager.animeMode, label: Label("Anime progress", systemImage: MediaType.anime.icon)) {
//                        ForEach(AnimeMode.allCases, id: \.self) { mode in
//                            Text(mode.displayName)
//                        }
//                    }
                }
                
                Section ("Contact"){
                    Link(destination: URL(string: "mailto:shiori.app@icloud.com")!) {
                        Label("Mail", systemImage: "envelope")
                    }
                    Link(destination: URL(string: "https://discord.gg/4ajqv3aMdd")!) {
                        Label {
                            Text("Discord")
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
                    Section("Account") {
                        Button(role: .destructive) {
                            showConfirmationDialog = true
                        } label: {
                            Text("Delete MyAnimeList account")
                        }
                        .confirmationDialog(
                            Text("You will be redirected to the MyAnimeList account deletion page."),
                            isPresented: $showConfirmationDialog,
                            titleVisibility: .visible
                        ) {
                            Button("Okay", role: .destructive) {
                                if let url = URL(string: "https://myanimelist.net/account_deletion") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
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
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .padding(.bottom, -30)
            
            Section("Info") {
                LabeledContent("App version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
                LabeledContent("Build number", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")
            }
            
            Section (
                header: Text("Languages"),
                footer:
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Translations are added through community contributions.")
                            .font(.footnote)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("If you want to contribute, please send a mail to:")
                                .font(.footnote)
                            Link("shiori.app@icloud.com", destination: URL(string: "mailto:shiori.app@icloud.com")!)
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
            ) {
                ForEach(SupportedLanguages.allCases, id: \.self) { language in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(language.displayName)
                        language.additionalInfoView
                    }
                }
            }
            
            Section ("Third-Party Services") {
                Link("MyAnimeList", destination: URL(string: "https://MyAnimeList.net")!)
                Link("Jikan", destination: URL(string: "https://jikan.moe")!)
            }
            
            Section ("Third-Party libraries") {
                Link("AlertToast", destination: URL(string: "https://github.com/elai950/AlertToast")!)
                Link("KeychainSwift", destination: URL(string: "https://github.com/evgenyneu/keychain-swift")!)
                Link("Nuke", destination: URL(string: "https://github.com/kean/Nuke")!)
                Link("TelemetryDeck", destination: URL(string: "https://telemetrydeck.com")!)
                Link("Pow", destination: URL(string: "https://movingparts.io/pow")!)
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

