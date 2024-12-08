import SwiftUI

struct SearchView: View {
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    @AppStorage("animeRankingType") private var animeRankingType = AnimeSortType.all
    @AppStorage("mangaRankingType") private var mangaRankingType = MangaSortType.all
    
    var body: some View {
        NavigationStack {
            VStack {
                ListView()
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
            Menu("Selection") {
                Picker("Manga or Anime", selection: $mediaType) {
                    Label("Manga", systemImage: "book").tag(MediaType.manga)
                    Label("Anime", systemImage: "tv").tag(MediaType.anime)
                }
            }
        }
    }
    
    private var sortMenu: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu("Sort by") {
                if mediaType == .anime {
                    animeSortPicker
                } else {
                    mangaSortPicker
                }
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
