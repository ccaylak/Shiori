import SwiftUI

struct GenreListView: View {
    let mode: String
    
    private let jikanGenresController = JikanGenresController()
    
    @State var jikanGenresResponse = JikanGenre(data: [])
    
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        List {
            ForEach(jikanGenresResponse.data, id: \.id) { genre in
                NavigationLink(destination: MediaGenresView(genreId: genre.malId, mode: mode, navigationTitle: genre.name)) {
                    LabeledContent {
                        Text(String(genre.count))
                    } label: {
                        Text((Genre(rawValue: genre.name) ?? .unknown).displayName)
                    }
                }
            }
        }
        .contentMargins(.top, 0)
        .navigationTitle(mode == "manga" ? "Manga genres" : "Anime genres")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                if mode == "manga" {
                    jikanGenresResponse = try await jikanGenresController.fetchMangaGenres()
                } else {
                    jikanGenresResponse = try await jikanGenresController.fetchAnimeGenres()
                }
                
            }
        }
    }
}
