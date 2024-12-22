import SwiftUI

struct ResultView: View {
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let profileController = ProfileController()
    
    @State var mediaResponse = MediaResponse(results: [], page: MediaResponse.Paging(next: ""))
    @State private var searchTerm: String = ""
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
                    }
                }
                if !mediaResponse.results.isEmpty, let nextPage = mediaResponse.page?.next, !nextPage.isEmpty {
                    Button(action: {
                        Task {
                            guard !isLoading else { return }
                            isLoading = true
                            do {
                                let newMediaResponse = try await profileController.fetchNextPage(nextPage)
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
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.automatic)
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            Task {
                await loadMediaData()
            }
        }
        .onAppear {
            Task {
                await loadMediaData()
            }
        }
        .onChange(of: animeRankingType) {
            Task {
                await loadMediaData()
            }
        }
        .onChange(of: mangaRankingType) {
            Task {
                await loadMediaData()
            }
        }
        .onChange(of: mediaType) {
            Task {
                await loadMediaData()
            }
        }
    }
    
    private func loadMediaData() async {
        isLoading = true
        do {
            switch mediaType {
            case .anime:
                mediaResponse = try await animeController.fetchPreviews(
                    searchTerm: searchTerm,
                    by: animeRankingType,
                    result: result
                )
            case .manga:
                mediaResponse = try await mangaController.fetchPreviews(
                    searchTerm: searchTerm,
                    by: mangaRankingType,
                    result: result
                )
            }
        } catch {
            print("Loading media data failed: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
}

#Preview {
    ResultView()
}
