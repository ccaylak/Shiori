import SwiftUI

struct SearchView: View {
    
    @AppStorage("mode") private var mode = "manga"
    @AppStorage("rankingType") private var rankingType = RankingType.all
    
    var body: some View {
        NavigationStack {
            VStack {
                ListView()
            }
            .navigationTitle(mode.capitalized)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Menu("Selection") {
                        Picker("Manga or Anime", selection: $mode) {
                            Label("Manga", systemImage: "book").tag("manga")
                            Label("Anime", systemImage: "tv").tag("anime")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu("Sort by") {
                        Picker("Sort by", selection: $rankingType) {
                            ForEach(RankingType.allCases, id: \.self) { type in
                                Label(type.displayName, systemImage: type.icon).tag(type)
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
