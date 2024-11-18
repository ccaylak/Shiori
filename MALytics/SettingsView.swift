import SwiftUI

struct SettingsView: View {
    
    @AppStorage("appAppereance") private var appAppereance = "system"
    @AppStorage("accentColor") private var accentColor = "blue"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    Picker("App Appereance", systemImage: "circle.lefthalf.filled",selection: $appAppereance) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Accent color", systemImage: "paintpalette.fill", selection: $accentColor) {
                        Text("Blue").tag("blue")
                        Text("Red").tag("red")
                        Text("Blue").tag("blue")
                    }
                    .pickerStyle(.palette)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
