import SwiftUI

struct ResultView: View {
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let userController = UserController()
    
    @State var mediaResponse = MediaResponse(data: [], paging: nil)
    @State private var searchTerm: String = ""
    
    @State private var isLoading = false
    
    @Environment(ResultSettings.self)
    private var resultSettings
    
    @Environment(AppSettings.self)
    private var settings
    
    @Environment(ToastManager.self)
    private var toastManager
    
    var body: some View {
        List {
            ForEach(mediaResponse.data, id: \.node.id) { media in
                NavigationLink {
                    DetailsView(media: media.node)
                } label: {
                    MediaView(
                        title: media.node.preferredTitle,
                        image: media.node.mainPicture.largeUrl,
                        releaseYear: media.node.isMangaOrAnime == .manga
                            ? media.node.yearLabel
                            : media.node.getStartSeason.seasonLabel,
                        type: media.node.specificMediaType,
                        mediaCount: media.node.resultCount,
                        status: media.node.specificStatus
                    )
                }
                .overlay(alignment: .topTrailing) {
                    AnyView(media.node.getEntryStatus.libraryIcon)
                }
            }
            if !mediaResponse.data.isEmpty, let nextPage = mediaResponse.paging?.next, !nextPage.isEmpty {
                Button{
                    Task {
                        guard !isLoading else { return }
                        isLoading = true
                        defer { isLoading = false }
                        
                        do {
                            let newMediaResponse = try await userController.fetchNextPage(nextPage)
                            mediaResponse.append(newMediaResponse.data)
                            mediaResponse.updatePaging(newMediaResponse.paging)
                        } catch {
                            print("Failed to load next page of results: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Group {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Load more")
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                .borderedProminentOrGlassProminent()
                .frame(maxWidth: .infinity, minHeight: 50)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .softScrollEdgeEffect(for: .top)
        .noScrollEdgeEffect(for: .bottom)
        .scrollIndicators(.automatic)
        .listStyle(.automatic)
        .listRowSpacing(10)
        .contentMargins(.top, 0)
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            guard searchTerm.count >= 3 else { return }
            Task {
                await loadMediaData()
            }
        }
        .onAppear {
            guard mediaResponse.data.isEmpty else { return }
            toastManager.isLoading = true
            
            Task {
                defer {
                    toastManager.isLoading = false
                }
                await loadMediaData()
            }
        }
        .onChange(of: resultSettings.needsToLoadData) {
            Task {
                await loadMediaData()
            }
        }
    }
    
    private func loadMediaData() async {
        do {
            switch resultSettings.seriesType {
            case .anime:
                mediaResponse = try await animeController.fetchPreviews(
                    searchTerm: searchTerm,
                    showNsfwContent: settings.showNsfwContent,
                    rankingType: resultSettings.animeRankingType
                )
            case .manga:
                mediaResponse = try await mangaController.fetchPreviews(
                    searchTerm: searchTerm,
                    showNsfwContent: settings.showNsfwContent,
                    rankingType: resultSettings.mangaRankingType
                )
            }
        } catch {
            print("Failed to load media data: \(error)")
        }
    }
}

#Preview {
    ResultView()
        .environment(ToastManager())
}

