import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settingsManager: SettingsManager = .shared
    
    private var tokenHandler: TokenHandler = .shared
    
    private let resultOptions = [10, 20, 50, 100]
    
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                Section(header: Text("App icon"), footer: Text("Icons made by Nicole Knutas")) {
                    VStack{
                        Image("AppIconSelector")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                        
                    }
                }
                
                Section ("Info") {
                    Link("GitHub repository", destination: URL(string: "https://github.com/ccaylak/MALytics")!)
                        .tint(Color.getByColorString(settingsManager.accentColor.rawValue))
                    
                    if tokenHandler.isAuthenticated {
                        Button(action: {
                            showConfirmationDialog = true
                        }) {
                            Text("Delete MyAnimeList account")
                                .foregroundColor(.red)
                        }
                        .confirmationDialog(Text("You will be redirected to the MyAnimeList account deletion page."),
                                            isPresented: $showConfirmationDialog,
                                            titleVisibility: .visible,
                                            actions: {
                            Button("Okay", role: .destructive) {
                                if let url = URL(string: "https://myanimelist.net/account_deletion") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        )
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
