import SwiftUI

struct MediaGenresView: View {
    
    let genreId: Int
    let mode: SeriesType
    let navigationTitle: String
    
    @State var jikanMedia = JikanMedia(data: [], pagination: nil)
    
    private let jikanGenresController = JikanGenresController()
    
    @EnvironmentObject private var alertManager: AlertManager
    
    @State var isLoading = false
    @State var page = 1
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(jikanMedia.data, id: \.id) { media in
                    NavigationLink(destination: DetailsView(media: MediaNode(
                        id: media.malId,
                        title: media.titles[0].title,
                        mainPicture: Picture(large: media.images.jpgImage.largeImage, medium: media.images.jpgImage.baseImage),
                        mediaType: mode.rawValue
                    ))) {
                        VStack {
                            AsyncImageView(imageUrl: media.images.jpgImage.baseImage)
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
                    .buttonStyle(.plain)
                }
            }
            if !jikanMedia.data.isEmpty,
               let pagination = jikanMedia.pagination,
               pagination.hasNextPage,
               pagination.currentPage < pagination.lastVisiblePage {
                Button {
                    Task {
                        guard !isLoading else { return }
                        isLoading = true
                        page+=1
                        do {
                            if mode == .anime {
                                let newJikanMedia = try await jikanGenresController.fetchAnimeByGenre(
                                    id: genreId,
                                    page: page
                                )
                                
                                jikanMedia.append(newJikanMedia.data)
                                
                                
                            } else {
                                let newJikanMedia = try await jikanGenresController.fetchMangaByGenre(
                                    id: genreId,
                                    page: page
                                )
                                
                                jikanMedia.append(newJikanMedia.data)
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
                if mode == .manga {
                    jikanMedia = try await jikanGenresController.fetchMangaByGenre(id: genreId, page: page)
                } else {
                    jikanMedia = try await jikanGenresController.fetchAnimeByGenre(id: genreId, page: page)
                }
            }
        }
    }
}
