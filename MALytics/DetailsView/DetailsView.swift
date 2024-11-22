import SwiftUI

struct DetailsView: View {
    
    @State var anime: Anime
    @State var isDescriptionExpanded = false
    @State var showImages = false
    
    let animeController = AnimeController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CoverAndDescriptionView(
                        title: anime.title,
                        imageUrl: anime.images.large,
                        rating: anime.rating ?? 0.0,
                        episodes: anime.episodes ?? 0,
                        description: anime.description ?? "LOL")
                }
                Divider()
                GeneralInformationView(mediaType: anime.mediaType ?? "", episodes: anime.episodes ?? 0, startDate: anime.startDate ?? "", endDate: anime.endDate ?? "", studios: anime.studios ?? [])
                Divider()
                GenresView(genres: anime.genres ?? [])
                Divider()
                StatisticsView(rating: anime.rating ?? 0.0, rank: anime.rank ?? 0, popularity: anime.popularity ?? 0)
                Divider()
                RelatedAnimesView(relatedAnimes: anime.relatedAnimes ?? [])
                Divider()
                RecommendationsView(recommendations: anime.recommendations ?? [])
                Divider()
                MoreImagesView(images: anime.moreImages ?? [])
            }
            .scrollIndicators(.hidden)
            .navigationTitle(anime.title)
            .padding(.horizontal)
            
        }.onAppear{
            Task {
                anime = try await animeController.loadAnimeDetails(animeId: anime.id)
            }
        }
    }
}

#Preview {
    DetailsView(anime: Anime(id: 36511, title: "Tokyo Ghoul", images: Images(medium: "https://cdn.myanimelist.net/images/anime/9/74398.jpg", large: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg")))
}
