import SwiftUI

struct ResultView: View {
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let profileController = ProfileController()
    
    @State var mediaResponse = MediaResponse(results: [], page: MediaResponse.Paging(next: ""))
    @State private var searchTerm: String = ""
    
    @State private var isInitialLoading = false
    @State private var isLoading = false
    
    @StateObject private var resultManager: ResultManager = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(mediaResponse.results, id: \.node.id) { media in
                    NavigationLink(destination: DetailsView(media: media.node)) {
                        MediaView(
                            title: media.node.getTitle,
                            image: media.node.getCover,
                            releaseYear: media.node.getReleaseYear,
                            type: media.node.getType,
                            mediaCount: (resultManager.mediaType == .anime) ? (media.node.getEpisodes) : (media.node.getChapters),
                            status: media.node.getMediaStatus
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
                                .background(Color.getByColorString(settingsManager.accentColor.rawValue))
                                .cornerRadius(10)
                        } else {
                            Text("Load more")
                                .frame(width: 370, height: 50)
                                .background(Color.getByColorString(settingsManager.accentColor.rawValue))
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
                if mediaResponse.results.isEmpty {
                    await loadMediaData()
                }
            }
        }
        .onChange(of: resultManager.needsToLoadData) {
            Task {
                await loadMediaData()
            }
        }
    }
    
    private func loadMediaData() async {
        isInitialLoading = true
        do {
            switch resultManager.mediaType {
            case .anime:
                mediaResponse = try await animeController.fetchPreviews(searchTerm: searchTerm)
            case .manga:
                mediaResponse = try await mangaController.fetchPreviews(searchTerm: searchTerm)
            case .unknown:
                print("test")
            }
        } catch {
            print("Loading media data failed: \(error.localizedDescription)")
        }
        isInitialLoading = false
    }
    
}

#Preview {
    ResultView()
}
