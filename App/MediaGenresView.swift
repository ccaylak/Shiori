import SwiftUI

struct MediaGenresView: View {
    
    let genreId: Int
    let mode: String
    let navigationTitle: String
    
    @State var jikanMediaResponse = JikanAnime(data: [], pagination: nil)
    
    private let jikanGenresController = JikanGenresController()
    
    @EnvironmentObject private var alertManager: AlertManager
    
    @State var isLoading = false
    @State var page = 1
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(jikanMediaResponse.data, id: \.id) { media in
                    NavigationLink(destination: DetailsView(media: Media(
                        id: media.malId,
                        title: media.titles[0].title,
                        images: Images(large: media.images.jpg.imageUrl),
                        type: (mode == "manga") ? "manga" : "tv"
                    ))) {
                        VStack {
                            AsyncImageView(imageUrl: media.images.jpg.imageUrl)
                                .frame(width: CoverSize.extraLarge.size.width, height: CoverSize.extraLarge.size.height)
                                .strokedBorder()
                                .cornerRadius(12)
                            
                            Text(media.titles[0].title)
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: CoverSize.extraLarge.size.width, alignment: .leading)
                        }
                        .padding(.bottom)
                    }
                }
            }
            if !jikanMediaResponse.data.isEmpty,
               let pagination = jikanMediaResponse.pagination,
               pagination.hasNextPage,
               pagination.currentPage < pagination.lastVisiblePage {
                Button {
                    Task {
                        guard !isLoading else { return }
                        isLoading = true
                        page+=1
                        do {
                            if mode == "anime" {
                                let newJikanMediaResponse = try await jikanGenresController.fetchAnimeByGenre(
                                    id: genreId,
                                    page: page
                                )
                                
                                jikanMediaResponse.data.append(contentsOf: newJikanMediaResponse.data)
                                
                                
                            } else {
                                let newJikanMediaResponse = try await jikanGenresController.fetchMangaByGenre(
                                    id: genreId,
                                    page: page
                                )
                                
                                jikanMediaResponse.data.append(contentsOf: newJikanMediaResponse.data)
                            }
                        }
                        
                        isLoading = false
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
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                if mode == "manga" {
                    jikanMediaResponse = try await jikanGenresController.fetchMangaByGenre(id: genreId, page: page)
                } else {
                    jikanMediaResponse = try await jikanGenresController.fetchAnimeByGenre(id: genreId, page: page)
                }
            }
        }
    }
}
