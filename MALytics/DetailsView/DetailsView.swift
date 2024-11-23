import SwiftUI

struct DetailsView: View {
    
    @State var media: Media
    @State var isDescriptionExpanded = false
    @State var showImages = false
    
    let malController = MyAnimeListAPIController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CoverAndDescriptionView(
                        title: media.title,
                        imageUrl: media.images.large,
                        rating: media.rating ?? 0.0,
                        episodes: media.episodes ?? 0,
                        description: media.description ?? "LOL",
                        typeString: media.mediaType ?? ""
                    )
                }
                Divider()
                
                GeneralInformationView(typeString: media.mediaType ?? "", episodes: media.episodes ?? 0, startDate: media.startDate ?? "", endDate: media.endDate ?? "", studios: media.studios ?? [], statusString: media.status ?? "")
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
                media = try await malController.loadAnimeDetails(animeId: media.id)
            }
        }
    }
}

#Preview {
    DetailsView(media: Media(id: 36511, title: "Tokyo Ghoul", images: Images(medium: "https://cdn.myanimelist.net/images/anime/9/74398.jpg", large: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg")))
}
