import SwiftUI

struct ResultView: View {
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let profileController = ProfileController()
    
    @State var mediaResponse = MediaResponse(results: [], page: MediaResponse.Paging(next: ""))
    @State private var searchTerm: String = ""
    
    @State private var isLoading = false
    
    @StateObject private var resultManager: ResultManager = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        List {
            ForEach(mediaResponse.results, id: \.node.id) { media in
                ZStack(alignment: .topTrailing) {
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

                    AnyView(media.node.getEntryStatus.libraryIcon)
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
                    } else {
                        Text("Load more")
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.getByColorString(settingsManager.accentColor.rawValue))
                .cornerRadius(10)
                .listRowInsets(EdgeInsets())
            }
        }
        .scrollIndicators(.automatic)
        .listStyle(.automatic)
        .listRowSpacing(10)
        .contentMargins(.top, 0)
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            Task {
                await loadMediaData()
            }
        }
        .onAppear {
            guard mediaResponse.results.isEmpty else { return }
            alertManager.isLoading = true
            
            Task {
                defer {
                    alertManager.isLoading = false
                }
                await loadMediaData()
            }
        }
        .onChange(of: resultManager.needsToLoadData) {
            Task {
                await loadMediaData()
            }
        }
    }
    
    private func loadMediaData() async {
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
    }
    
}

#Preview {
    ResultView()
        .environmentObject(AlertManager.shared)
}
