import SwiftUI

struct DetailsView: View {
    
    @State var media: Media
    @State var isDescriptionExpanded = false
    @State var showImages = false
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    
    let malController = MyAnimeListAPIController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if (mediaType == .anime) {
                        CoverAndDescriptionView(
                            title: media.title,
                            imageUrl: media.images.large,
                            rating: media.rating ?? 0.0,
                            mediaCount: media.episodes ?? 0,
                            description: media.description ?? "Unknown",
                            typeString: media.type ?? "Unknown"
                        )
                    }
                    if (mediaType == .manga) {
                        CoverAndDescriptionView(
                            title: media.title,
                            imageUrl: media.images.large,
                            rating: media.rating ?? 0.0,
                            mediaCount: media.numberOfChapters ?? 0,
                            description: media.description ?? "LOL",
                            typeString: media.type ?? "Unknown"
                        )
                    }
                }
                Divider()
                
                if (mediaType == .anime) {
                    GeneralInformationView(
                        typeString: media.type ?? "Unknown",
                        episodes: media.episodes ?? 0,
                        numberOfChapters: nil,
                        numberOfVolumes: nil,
                        startDate: media.startDate ?? "Unknown",
                        endDate: media.endDate ?? "",
                        studios: media.studios ?? [],
                        authorInfos: [],
                        statusString: media.status ?? "Unknown"
                    )
                }
                
                if (mediaType == .manga) {
                    GeneralInformationView(
                        typeString: media.type ?? "Unknown",
                        episodes: nil,
                        numberOfChapters: media.numberOfChapters ?? 0,
                        numberOfVolumes: media.numberOfVolumes,
                        startDate: media.startDate ?? "Unknown",
                        endDate: media.endDate ?? "",
                        studios: [],
                        authorInfos: media.authors ?? [],
                        statusString: media.status ?? "Unknown"
                    )
                }
                Divider()
                
                if let genres = media.genres, !genres.isEmpty {
                    GenresView(genres: genres)
                    Divider()
                }
                
                StatisticsView(rating: media.rating ?? 0.0, rank: media.rank ?? 0, popularity: media.popularity ?? 0)
                Divider()
                
                if let relatedAnimes = media.relatedAnimes, !relatedAnimes.isEmpty {
                    RelatedMediaView(relatedMediaItems: relatedAnimes)
                    Divider()
                }
                
                if let relatedMangas = media.relatedMangas, !relatedMangas.isEmpty {
                    RelatedMediaView(relatedMediaItems: relatedMangas)
                    Divider()
                }
                
                if let recommendations = media.recommendations, !recommendations.isEmpty {
                    RecommendationsView(recommendations: recommendations)
                    Divider()
                }
                
                if let moreImages = media.moreImages, moreImages.count >= 3 {
                    MoreImagesView(images: moreImages)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle(media.title)
            .padding(.horizontal)
            
        }.onAppear{
            Task {
                if(mediaType == .anime) {
                    media = try await malController.loadAnimeDetails(animeId: media.id)
                    
                }
                if(mediaType == .manga) {
                    
                    media = try await malController.loadMangaDetails(mangaId: media.id)
                    
                }
                
            }
        }
    }
}

#Preview {
    DetailsView(
        media: Media(
            id: 36511,
            title: "Tokyo Ghoul",
            images: Images(
                medium: "https://cdn.myanimelist.net/images/anime/9/74398.jpg",
                large: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg"
            ),
            startDate: "2020-01-01",
            type: AnimeType.tv.rawValue,
            status: "finished",
            episodes: 10,
            numberOfVolumes: 10,
            numberOfChapters: 20,
            authors: [
                AuthorInfos(
                    author: AuthorInfos.Author(
                        id: 1,
                        firstName: "Sui",
                        lastName: "Ishida"
                    ),
                    role: "Writer"
                )
            ]
        )
    )
}
