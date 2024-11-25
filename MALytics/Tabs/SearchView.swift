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
                ToolbarItem(placement: .cancellationAction) {
                    Menu("Selection") {
                        Picker("Manga or Anime", selection: $mediaType) {
                            Label("Manga", systemImage: "book").tag(MediaType.manga)
                            Label("Anime", systemImage: "tv").tag(MediaType.anime)
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                        if (mediaType == .anime) {
                            Menu("Sort by") {
                                Picker("Sort by", selection: $animeRankingType) {
                                    ForEach(AnimeSortType.allCases, id: \.self) { animeType in
                                        Label(animeType.displayName, systemImage: animeType.icon).tag(animeType)
                                    }
                                }
                            }
                        }
                        if (mediaType == .manga) {
                            Menu("Sort by") {
                                Picker("Sort by", selection: $mangaRankingType) {
                                    ForEach(MangaSortType.allCases, id: \.self) { mangaType in
                                        Text(mangaType.displayName).tag(mangaType)
                                    }
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
