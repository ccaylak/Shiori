import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settingsManager: SettingsManager = .shared
    
    private var tokenHandler: TokenHandler = .shared
    
    private let resultOptions = [10, 20, 50, 100]
    
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
                            Text(appearance.rawValue.capitalized).tag(appearance)
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
                }
                Section("List") {
                    Picker("Results per page", systemImage: "list.bullet.rectangle", selection: $settingsManager.resultsPerPage) {
                        ForEach(resultOptions, id: \.self) { resultOption in
                            Text(String(resultOption)).tag(resultOption)
                        }
                    }
                    Picker("Title language", systemImage: "translate", selection: $settingsManager.titleLanguage) {
                        ForEach(TitleLanguage.allCases, id: \.self) { selectedLanguage in
                            Text(selectedLanguage.rawValue.capitalized).tag(selectedLanguage)
                        }
                    }
                    
                    /* todo
                     HStack {
                     Label("Show airing banner", systemImage: "flag")
                     Spacer()
                     Button {
                     settingsManager.showAiringSoonBanner.toggle()
                     } label: {
                     ZStack(alignment: .centerFirstTextBaseline) {
                     Image(systemName: "flag.slash")
                     .hidden()
                     .imageScale(.large)
                     Image(systemName: settingsManager.showAiringSoonBanner ? "flag" : "flag.slash")
                     .contentTransition(.symbolEffect(.replace))
                     .imageScale(.large)
                     }
                     .foregroundColor(.accentColor)
                     .symbolRenderingMode(.hierarchical)
                     }
                     .buttonStyle(.borderless)
                     }
                     */
                }
                
                let icons: [(name: String, title: String)] = [
                    (name: "AppIcon", title: String(localized: "Default")),
                    (name: "ShioriIcon", title: String(localized: "Shiori-chan"))
                ]
                
                Section(
                    header: Text("App icons"),
                    footer:
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Icons made by Nicole Knutas")
                            Text("Shiori-chan illustrated by Lara Prüß")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                ) {
                    HStack (spacing: 13){
                        ForEach(icons, id: \.name) { icon in
                            VStack{
                                Image(uiImage: UIImage(named: icon.name)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                    .onTapGesture {
                                        changeAppIcon(to: icon.name == "AppIcon" ? nil : icon.name)
                                    }
                                Text(icon.title)
                                    .font(.caption2)
                                    .frame(width: 70, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                }
                
                Section (
                    header: Text("Contact"),
                    footer: Text("You can contact me for feedback, bugs or feature requests")
                )
                {
                    
                    Link(destination: URL(string: "mailto:shiori.app@icloud.com")!) {
                        Label("Mail", systemImage: "envelope")
                    }
                    Link(destination: URL(string: "https://discordapp.com/users/239715812506599424")!) {
                        HStack(spacing: 19) {
                            Image("discord_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Discord")
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

private func changeAppIcon(to iconName: String?) {
    
    UIApplication.shared.setAlternateIconName(iconName) { error in
        if let error = error {
            print("Error setting alternate icon \(error.localizedDescription)")
        }
    }
}

private struct AboutView: View {
    var body: some View {
        Form {
            Section("Info") {
                LabeledContent("App version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "–")
                HStack (spacing: 25) {
                    Image("github_icon")
                        .resizable()
                         .scaledToFit()
                        .frame(width: 20, height: 20)
                    Link("Repository", destination: URL(string: "https://github.com/ccaylak/Shiori")!)
                        .foregroundStyle(.primary)
                }
                NavigationLink(destination: ShioriChanView()) {
                    Label("Shiori-chan", systemImage: "character.ja")
                }
            }
            
            Section (
                header: Text("Supported languages"),
                footer:
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Translations are added through community contributions.")
                            .font(.footnote)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("If you want to contribute, please send me a mail:")
                                .font(.footnote)
                            Link("shiori.app@icloud.com", destination: URL(string: "mailto:shiori.app@icloud.com")!)
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
            ) {
                Text("German")
                Text("English")
            }
            
            Section ("Used Third-Party Services") {
                Link("MyAnimeList", destination: URL(string: "https://MyAnimeList.net")!)
                Link("Jikan", destination: URL(string: "https://jikan.moe")!)
            }
            
            Section ("Used Third-Party libraries") {
                Link("AlertToast", destination: URL(string: "https://github.com/elai950/AlertToast")!)
                Link("KeychainSwift", destination: URL(string: "https://github.com/evgenyneu/keychain-swift")!)
                Link("Nuke", destination: URL(string: "https://github.com/kean/Nuke")!)
                Link("TelemetryDeck", destination: URL(string: "https://telemetrydeck.com")!)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("About Shiori")
    }
}

private struct ShioriChanView: View {
    var body: some View {
        Form {
            Section(
                header: Text("Shiori-chan"),
                footer: Text("Illustrated by Lara Prüß")
            ) {
                Image("shiori_chan")
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

#Preview {
    SettingsView()
}
