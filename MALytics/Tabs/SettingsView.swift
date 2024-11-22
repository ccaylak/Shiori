import SwiftUI

struct SettingsView: View {
    
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("accentColor") private var accentColor = "blue"
    @AppStorage("result") private var result = 10
    
    private let appearanceOptions = ["system", "light", "dark"]
    private let accentColorOptions = ["blue", "red", "orange", "pink", "purple"]
    private let resultOptions = [10,20,50,100]
    private let modeOptions = ["anime"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    Picker("Appearance", systemImage: "circle.lefthalf.filled", selection: $appearance) {
                        ForEach(appearanceOptions, id: \.self) { appearance in
                            Text(appearance.capitalized).tag(appearance)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Accent Color", systemImage: "circle.fill", selection: $accentColor) {
                        ForEach(accentColorOptions, id: \.self) { accentColor in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.getByColorString(accentColor))
                                Text(accentColor.capitalized)
                            }.tag(accentColor)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("List") {
                    Picker("Result set amount", systemImage: "list.bullet.rectangle", selection: $result) {
                        ForEach(resultOptions, id: \.self) { result in
                            Text(String(result)).tag(result)
                        }
                    }
                }
                
                Section ("Info") {
                    Link("GitHub-Repository", destination: URL(string: "https://github.com/ccaylak/MALytics")!)
                        .foregroundColor(Color.getByColorString(accentColor))
                }
            }.navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
