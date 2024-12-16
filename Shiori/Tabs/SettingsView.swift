import SwiftUI

struct SettingsView: View {
    @AppStorage("appearance") private var appearance = Appearance.system
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    @AppStorage("result") private var resultsPerPage = 10
    
    private let resultOptions = [10, 20, 50, 100]
    
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
                    
                    ShareLink(item: URL(string: "https://testflight.apple.com/join/NudPcSvv")!) {
                        Text("Share TestFlight invite")
                    }
                    
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
