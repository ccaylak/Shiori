import SwiftUI

struct SearchView: View {
    
    @State private var mode = "anime"
    
    var body: some View {
        NavigationStack {
            VStack {
                if mode == "anime" {
                    AnimeListView()
                } else {
                }
            }
            .navigationTitle(mode.capitalized)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker(selection: $mode, label: Text("Auswahl, ob Manga oder Anime")) {
                            Label("Manga", systemImage: "book").tag("mange")
                            Label("Anime", systemImage: "tv").tag("anime")
                        }
                    }
                    label: {
                        Label("Sort", systemImage: "sparkles")
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
