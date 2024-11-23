import SwiftUI

struct ListView: View {
    
    private let malController = MyAnimeListAPIController()
    
    @State var mediaResponse = MediaResponse(results: [], page: MediaResponse.Paging(next: ""))
    @State private var searchTerm = ""
    @State private var isLoading = false
    
    @AppStorage("rankingType") private var rankingType = RankingType.all
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(mediaResponse.results, id: \.node.id) { media in
                    NavigationLink(destination: DetailsView(media: media.node)) {
                        MediaView(title: media.node.title, image: media.node.images.large, episodes: media.node.episodes ?? 0, releaseYear: String(media.node.startDate?.prefix(4) ?? "Unknown"), rating: media.node.rating ?? 0.0, typeString: media.node.mediaType ?? "Unknown", statusString: media.node.status ?? "Unknown")
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
                mediaResponse = try await malController.loadAnimePreviews(searchTerm: searchTerm)
            }
        }
        .onAppear {
            Task {
                mediaResponse = try await malController.loadAnimeRankings()
            }
        }
        .onChange(of: rankingType) {
            Task {
                mediaResponse = try await malController.loadAnimeRankings()
            }
        }
    }
}

#Preview {
    ListView()
}
