import SwiftUI

struct ListView: View {
    
    private let malController = MyAnimeListAPIController()
    
    @State var mediaResponse = MediaResponse(results: [], page: MediaResponse.Paging(next: ""))
    @State private var searchTerm = ""
    @State private var isLoading = false
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
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
                            releaseYear: String(media.node.startDate?.prefix(4) ?? "Unknown"),
                            type: media.node.type ?? "Unknown",
                            status: media.node.status ?? "Unknown",
                            mediaCount: media.node.episodes ?? 0
                        )
                    }
                }
            }
            if !mediaResponse.results.isEmpty, let nextPage = mediaResponse.page?.next, !nextPage.isEmpty {
                Button(action: {
                    Task {
                        guard !isLoading else { return }
                        isLoading = true
                        do {
                            let newMediaResponse = try await malController.loadNextPage(nextPage)
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
        .searchable(text: $searchTerm)
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
                mediaResponse = try await malController.loadAnimeRankings()
            case .manga:
                mediaResponse = try await malController.loadMangaRankings()
            }
        } catch {
            print("Loading rankings failed: \(error.localizedDescription)")
        }
    }
    
    private func loadPreviews(for searchTerm: String) async {
        do {
            switch mediaType {
            case .anime:
                mediaResponse = try await malController.loadAnimePreviews(searchTerm: searchTerm)
            case .manga:
                mediaResponse = try await malController.loadMangaPreviews(searchTerm: searchTerm)
            }
        } catch {
            print("Fehler beim Laden der Previews: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ListView()
}
