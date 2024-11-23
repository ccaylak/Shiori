import SwiftUI

struct ListView: View {
    
    private let malController = MyAnimeListAPIController()
    
    @State var animeResponse = AnimeResponse(results: [], page: AnimeResponse.Paging(next: ""))
    @State private var searchTerm = ""
    @State private var isLoading = false
    
    @AppStorage("rankingType") private var rankingType = RankingType.all
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(animeResponse.results, id: \.node.id) { anime in
                    NavigationLink(destination: DetailsView(anime: anime.node)) {
                        AnimeView(title: anime.node.title, image: anime.node.images.large, episodes: anime.node.episodes ?? 0, releaseYear: String(anime.node.startDate?.prefix(4) ?? "Unknown"), rating: anime.node.rating ?? 0.0, typeString: anime.node.mediaType ?? "Unknown", statusString: anime.node.status ?? "Unknown")
                    }
                }
            }
            if !animeResponse.results.isEmpty, let nextPage = animeResponse.page?.next, !nextPage.isEmpty {
                Button(action: {
                    Task {
                        guard !isLoading else { return }
                        isLoading = true
                        do {
                            let newAnimeResponse = try await malController.loadNextPage(nextPage)
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
                            .background(Color.getByColorString(accentColor.rawValue))
                            .cornerRadius(10)
                    } else {
                        Text("Load more")
                            .frame(width: 370, height: 50)
                            .background(Color.getByColorString(accentColor.rawValue))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .searchable(text: $searchTerm)
        .onSubmit(of: .search) {
            Task {
                animeResponse = try await malController.loadAnimePreviews(searchTerm: searchTerm)
            }
        }
        .onAppear {
            Task {
                animeResponse = try await malController.loadAnimeRankings()
            }
        }
        .onChange(of: rankingType) {
            Task {
                animeResponse = try await malController.loadAnimeRankings()
            }
        }
    }
}

#Preview {
    ListView()
}
