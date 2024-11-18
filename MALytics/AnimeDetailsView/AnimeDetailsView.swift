import SwiftUI

struct AnimeDetailsView: View {
    
    @State var anime: Anime
    @State var isDescriptionExpanded = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    AnimeCoverAndDescriptionView(
                        title: anime.title,
                        imageUrl: anime.images.large,
                        rating: anime.rating ?? 0.0,
                        episodes: anime.episodes ?? 0,
                        mediaType: anime.mediaType ?? "Unknown",
                        year: anime.startDate ?? "Lol",
                        description: anime.description ?? "LOL")
                }
                Divider()
                GenresView(genres: anime.genres ?? [])
                Divider()
                VStack(alignment: .leading) {
                    Text("Recommendations")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(anime.recommendations ?? [], id: \.self)  {recommendation in
                                HStack {
                                    NavigationLink(destination: AnimeDetailsView(anime: recommendation.node)) {
                                        AsyncImageView(imageUrl: recommendation.node.images.large)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 110, alignment: .leading)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .frame(height: 150)
                    }
                    .scrollIndicators(.hidden)
                }
                Divider()
                
            }
            .navigationTitle(anime.title)
            .padding(.horizontal)
            
        }.onAppear{
            Task {
                await loadAnimeDetails()
            }
        }
    }
    
    func loadAnimeDetails() async {
        let baseURL = "https://api.myanimelist.net/v2/anime/\(anime.id)"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "fields", value: "mean,synopsis,mean,genres,status,recommendations,statistics,media_type,start_date,num_episodes")
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedAnime = try JSONDecoder().decode(Anime.self, from: data)
            anime = decodedAnime
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
    }
}

#Preview {
    AnimeDetailsView(anime: Anime(id: 36511, title: "Tokyo Ghoul", images: Images(medium: "https://cdn.myanimelist.net/images/anime/9/74398.jpg", large: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg")))
}
