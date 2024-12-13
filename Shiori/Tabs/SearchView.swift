import SwiftUI

struct SearchView: View {
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    @AppStorage("animeRankingType") private var animeRankingType = AnimeSortType.all
    @AppStorage("mangaRankingType") private var mangaRankingType = MangaSortType.all
    
    @State private var isOn = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ResultView()
                    .scrollIndicators(.visible)
            }
            .navigationTitle(mediaType.rawValue.capitalized)
            .toolbar {
                selectionMenu
                sortMenu
            }
        }
    }
    
    private var selectionMenu: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Menu {
                Text("Select media")
                Picker("Manga oder Anime", selection: $mediaType) {
                    Label("Manga", systemImage: "book")
                        .tag(MediaType.manga)
                    Label("Anime", systemImage: "tv")
                        .tag(MediaType.anime)
                }
            } label: {
                Label("Media selection", systemImage: "sparkles")
            }
        }
    }

    
    private var sortMenu: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Text("Sort by")
                if mediaType == .anime {
                    animeSortPicker
                } else {
                    mangaSortPicker
                }
            } label: {
                Label("Sorting method", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    
    private var animeSortPicker: some View {
        Picker("Sort by", selection: $animeRankingType) {
            ForEach(AnimeSortType.allCases, id: \.self) { type in
                Label(type.displayName, systemImage: type.icon).tag(type)
            }
        }
    }
    
    private var mangaSortPicker: some View {
        Picker("Sort by", selection: $mangaRankingType) {
            ForEach(MangaSortType.allCases, id: \.self) { type in
                Text(type.displayName).tag(type)
            }
        }
    }
}

#Preview {
    SearchView()
}
