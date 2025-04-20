import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = Appearance.system
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    @AppStorage("result") private var resultsPerPage = 10
    @AppStorage("nsfw") private var showNSFW = false
    @AppStorage("titleLanguage") private var titleLanguage = TitleLanguage.english
    
    private var tokenHandler: TokenHandler = .shared
    
    private let resultOptions = [10, 20, 50, 100]
    
    @State private var showConfirmationDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    Picker("Appearance", systemImage: "circle.lefthalf.filled", selection: $appearance) {
                        ForEach(Appearance.allCases, id: \.self) { appearance in
                            Text(appearance.rawValue.capitalized).tag(appearance)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Accent Color", systemImage: "circle.fill", selection: $accentColor) {
                        ForEach(AccentColor.allCases, id: \.self) { accentColor in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.getByColorString(accentColor.rawValue))
                                Text(accentColor.rawValue.capitalized)
                            }.tag(accentColor)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Show NSFW-Content", systemImage: "eye.trianglebadge.exclamationmark.fill", selection: $showNSFW) {
                        Text("Yes")
                            .tag(true)
                        Text("No")
                            .tag(false)
                    }
                    .pickerStyle(.menu)
                    .tint(.secondary)
                }
                Section("List") {
                    Picker("Results per page", systemImage: "list.bullet.rectangle", selection: $resultsPerPage) {
                        ForEach(resultOptions, id: \.self) { resultOption in
                            Text(String(resultOption)).tag(resultOption)
                        }
                    }
                }
                
                Section ("Info") {
                    Link("GitHub-Repository", destination: URL(string: "https://github.com/ccaylak/MALytics")!)
                        .tint(Color.getByColorString(accentColor.rawValue))
                    
                    if tokenHandler.isAuthenticated {
                        Button(action: {
                            showConfirmationDialog = true
                        }) {
                            Text("Delete MyAnimeList Account")
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
