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
                            typeString: media.node.type ?? "Unknown",
                            statusString: media.node.status ?? "Unknown",
                            episodes: media.node.episodes ?? 0,
                            numberOfVolumes: media.node.numberOfVolumes ?? 0,
                            numberOfChapters: media.node.numberOfChapters ?? 0,
                            authors: media.node.authors ?? []
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
                if(mediaType == .anime) {
                    mediaResponse = try await malController.loadAnimePreviews(searchTerm: searchTerm)
                }
                    
                if (mediaType == .manga) {
                    mediaResponse = try await malController.loadMangaPreviews(searchTerm: searchTerm)
                }
                    
            }
        }
        .onAppear {
            Task {
                if (mediaType == .anime) {
                    mediaResponse = try await malController.loadAnimeRankings()
                }
                if (mediaType == .manga) {
                        mediaResponse = try await malController.loadMangaRankings()
                }
            }
        }
        .onChange(of: animeRankingType) {
            Task {
                mediaResponse = try await malController.loadAnimeRankings()
            }
        }
        .onChange(of: mangaRankingType) {
            Task {
                mediaResponse = try await malController.loadMangaRankings()
            }
        }
        .onChange(of: mediaType) {
            Task {
                if (mediaType == .anime){
                    mediaResponse = try await malController.loadAnimeRankings()
                }
                if (mediaType == .manga){
                    mediaResponse = try await malController.loadMangaRankings()
                }
            }
        }
    }
}

#Preview {
    ListView()
}
