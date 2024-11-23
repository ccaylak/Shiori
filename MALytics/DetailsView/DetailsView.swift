import SwiftUI

struct DetailsView: View {
    
    @State var anime: Anime
    @State var isDescriptionExpanded = false
    @State var showImages = false
    
    let malController = MyAnimeListAPIController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CoverAndDescriptionView(
                        title: anime.title,
                        imageUrl: anime.images.large,
                        rating: anime.rating ?? 0.0,
                        episodes: anime.episodes ?? 0,
                        description: anime.description ?? "LOL",
                        typeString: anime.mediaType ?? ""
                    )
                }
                Divider()
                
                GeneralInformationView(typeString: anime.mediaType ?? "", episodes: anime.episodes ?? 0, startDate: anime.startDate ?? "", endDate: anime.endDate ?? "", studios: anime.studios ?? [], statusString: anime.status ?? "")
                Divider()
                
                if let genres = anime.genres, !genres.isEmpty {
                    GenresView(genres: genres)
                    Divider()
                }
                
                StatisticsView(rating: anime.rating ?? 0.0, rank: anime.rank ?? 0, popularity: anime.popularity ?? 0)
                Divider()
                
                if let relatedAnimes = anime.relatedAnimes, !relatedAnimes.isEmpty {
                    RelatedAnimesView(relatedAnimes: relatedAnimes)
                    Divider()
                }
                
                if let recommendations = anime.recommendations, !recommendations.isEmpty {
                    RecommendationsView(recommendations: recommendations)
                    Divider()
                }
                
                if let moreImages = anime.moreImages, moreImages.count >= 3 {
                    MoreImagesView(images: moreImages)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle(anime.title)
            .padding(.horizontal)
            
        }.onAppear{
            Task {
                anime = try await malController.loadAnimeDetails(animeId: anime.id)
            }
        }
    }
}

#Preview {
    DetailsView(anime: Anime(id: 36511, title: "Tokyo Ghoul", images: Images(medium: "https://cdn.myanimelist.net/images/anime/9/74398.jpg", large: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg")))
}
