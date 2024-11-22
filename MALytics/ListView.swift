import SwiftUI

struct ListView: View {
    
    private let animeController = AnimeController()
    
    @State var animeResponse = AnimeResponse(results: [], page: AnimeResponse.Paging(next: ""))
    @State private var searchTerm = ""
    @State private var isLoading = false
    
    @AppStorage("rankingType") private var rankingType = "all"
    @AppStorage("accentColor") private var accentColor = "blue"
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(animeResponse.results, id: \.node.id) { anime in
                    NavigationLink(destination: DetailsView(anime: anime.node)) {
                        AnimeView(title: anime.node.title, image: anime.node.images.large, episodes: anime.node.episodes ?? 0, releaseYear: String(anime.node.startDate?.prefix(4) ?? "Unknown"), rating: anime.node.rating ?? 0.0, type: anime.node.mediaType ?? "Unknown")
                    }
                }
            }
            Button(action: {
                Task {
                    guard !isLoading, let nextPage = animeResponse.page?.next, !nextPage.isEmpty else {
                        return
                    }
                    isLoading = true
                    do {
                        let newAnimeResponse = try await animeController.loadNextPage(nextPage)
                        animeResponse.results.append(contentsOf: newAnimeResponse.results)
                        animeResponse.page = newAnimeResponse.page
                    } catch {
                        print("Fehler beim Laden der nächsten Seite: \(error.localizedDescription)")
                    }
                    isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                        .frame(width: 370, height: 50)
                        .background(Color.getByColorString(accentColor))
                        .cornerRadius(10)
                } else {
                    Text("Load more")
                        .frame(width: 370, height: 50)
                        .background(Color.getByColorString(accentColor))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .searchable(text: $searchTerm)
        .onSubmit(of: .search) {
            Task {
                
            }
        }
        .onAppear {
            Task {
                animeResponse = try await animeController.loadAnimeRankings()
            }
        }
        .onChange(of: rankingType) {
            Task {
                animeResponse = try await animeController.loadAnimeRankings()
            }
        }
    }
}

#Preview {
    ListView()
}
