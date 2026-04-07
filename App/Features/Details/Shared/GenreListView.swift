import SwiftUI

struct GenreListView: View {
    let mode: SeriesType
    
    private let jikanGenresController = JikanGenresController()
    
    @State private var jikanGenresResponse = JikanGenre(data: [])
    
    @EnvironmentObject private var alertManager: AlertManager
    
    private var groupedGenres: [(title: String, items: [JikanGenreData])] {
        let grouped = Dictionary(grouping: jikanGenresResponse.data) { genre in
            MediaCategory(name: genre.name).sectionTitle
        }
        
        let order = [
            String(localized: "Demographics"),
            String(localized: "Explicit Genres"),
            String(localized: "Genres"),
            String(localized: "Themes"),
            String(localized: "Other")
        ]
        
        return order.compactMap { title in
            guard let items = grouped[title] else { return nil }
            return (title, items)
        }
    }
    
    var body: some View {
        List {
            ForEach(groupedGenres, id: \.title) { group in
                Section {
                    ForEach(group.items, id: \.malId) { genre in
                        let mediaCategory = MediaCategory(name: genre.name)

                        NavigationLink(
                            destination: MediaGenresView(genreId: genre.malId, mode: mode, navigationTitle: mediaCategory.displayName)
                        ) {
                            LabeledContent {
                                Text(String(genre.count))
                            } label: {
                                Text(mediaCategory.displayName)
                            }
                        }
                    }
                } header: {
                    Text(group.title)
                }
            }
        }
        .contentMargins(.top, 0)
        .navigationTitle(mode == .manga ? "Manga Genres" : "Anime Genres")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            alertManager.isLoading = true
            defer { alertManager.isLoading = false }
            
            do {
                if mode == .manga {
                    jikanGenresResponse = try await jikanGenresController.fetchMangaGenres()
                } else {
                    jikanGenresResponse = try await jikanGenresController.fetchAnimeGenres()
                }
            } catch {
                print(error)
            }
        }
    }
}
