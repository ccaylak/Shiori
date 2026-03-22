import SwiftUI

struct ResultView: View {
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let userController = UserController()
    
    @State var mediaResponse = MediaResponse(data: [], paging: nil)
    @State private var searchTerm: String = ""
    
    @State private var isLoading = false
    
    @StateObject private var resultManager: ResultManager = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        List {
            ForEach(mediaResponse.data, id: \.node.id) { media in
                ZStack(alignment: .topTrailing) {
                    NavigationLink(destination: DetailsView(media: media.node)) {
                        MediaView(
                            title: media.node.preferredTitle,
                            image: media.node.mainPicture.largeUrl,
                            releaseYear: media.node.isMangaOrAnime == .manga ? media.node.yearLabel : media.node.getStartSeason.seasonLabel,
                            type: media.node.specificMediaType,
                            mediaCount: media.node.resultCount,
                            status: media.node.specificStatus
                        )
                    }
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
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .contentMargins(.horizontal, 0, for: .scrollContent)
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
            switch resultManager.seriesType {
            case .anime:
                mediaResponse = try await animeController.fetchPreviews(searchTerm: searchTerm)
            case .manga:
                mediaResponse = try await mangaController.fetchPreviews(searchTerm: searchTerm)
            }
        } catch {
            print("Failed to load media data: \(error)")
        }
    }
}

#Preview {
    ResultView()
        .environmentObject(AlertManager.shared)
}

