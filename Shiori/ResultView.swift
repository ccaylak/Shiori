import SwiftUI

struct ResultView: View {
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let profileController = ProfileController()
    
    @State var mediaResponse = MediaResponse(results: [], page: MediaResponse.Paging(next: ""))
    @State private var searchTerm = ""
    @State private var isLoading = false
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    @AppStorage("result") private var result = 10
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    
    @AppStorage("animeRankingType") private var animeRankingType = AnimeSortType.all
    @AppStorage("mangaRankingType") private var mangaRankingType = MangaSortType.all
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(mediaResponse.results, id: \.node.id) { media in
                    NavigationLink(destination: DetailsView(media: media.node)) {
                        MediaView(
                            title: media.node.title,
                            image: media.node.images.large,
                            releaseYear: media.node.getReleaseYear,
                            type: media.node.getType,
                            status: media.node.getStatus,
                            mediaCount: (mediaType == .anime) ? (media.node.getEpisodes) : (media.node.getChapters)
                        )
                        .padding(.horizontal)
                    }
                }
            }
            if !mediaResponse.results.isEmpty, let nextPage = mediaResponse.page?.next, !nextPage.isEmpty {
                Button(action: {
                    Task {
                        guard !isLoading else { return }
                        isLoading = true
                        do {
                            let newMediaResponse = try await profileController.loadNextPage(nextPage)
                            mediaResponse.results.append(contentsOf: newMediaResponse.results)
                            mediaResponse.page = newMediaResponse.page
                        } catch {
                            print("Failed to load next page of results: \(error.localizedDescription)")
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
        .scrollIndicators(.automatic)
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            Task {
                await loadPreviews(for: searchTerm)
            }
        }
        .onAppear {
            Task {
                await loadRankings()
            }
        }
        .onChange(of: animeRankingType) {
            Task {
                await loadRankings()
            }
        }
        .onChange(of: mangaRankingType) {
            Task {
                await loadRankings()
            }
        }
        .onChange(of: mediaType) {
            Task {
                await loadRankings()
            }
        }
    }
    
    private func loadRankings() async {
        do {
            switch mediaType {
            case .anime:
                mediaResponse = try await animeController.fetchAnimeRankings(result: result, by: animeRankingType)
            case .manga:
                mediaResponse = try await mangaController.fetchMangaRankings(result: result, by: mangaRankingType)
            }
        } catch {
            print("Loading rankings failed: \(error.localizedDescription)")
        }
    }
    
    private func loadPreviews(for searchTerm: String) async {
        do {
            switch mediaType {
            case .anime:
                mediaResponse = try await animeController.fetchAnimePreviews(searchTerm: searchTerm, result: result)
            case .manga:
                mediaResponse = try await mangaController.fetchMangaPreviews(searchTerm: searchTerm, result: result)
            }
        } catch {
            print("Fehler beim Laden der Previews: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ResultView()
}
