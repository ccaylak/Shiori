import SwiftUI

struct SearchView: View {
    
    @AppStorage("mode") private var mode = "manga"
    @AppStorage("rankingType") private var rankingType = "all"
    
    let rankingTypes: [(key: String, icon: String)] = [
        ("all", "star"),
        ("airing", "clock"),
        ("upcoming", "calendar"),
        ("tv", "tv"),
        ("ova", "play.circle"),
        ("movie", "film"),
        ("special", "sparkles"),
        ("bypopularity", "chart.xyaxis.line"),
        ("favorite", "heart")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ListView()
            }
            .navigationTitle(mode.capitalized)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Menu("Selection") {
                        Picker(selection: $mode, label: Text("Manga or Anime")) {
                            Label("Manga", systemImage: "book").tag("manga")
                            Label("Anime", systemImage: "tv").tag("anime")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu("Sort by") {
                        Picker(selection: $rankingType, label: Text("Sort by decision")) {
                            ForEach(rankingTypes, id: \.key) { rankingType in
                                Label((rankingType.key.capitalized)==("Bypopularity") ? "Popularity" : "\(rankingType.key.capitalized)", systemImage: rankingType.icon).tag(rankingType.key)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
