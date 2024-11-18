import SwiftUI

struct AnimeListView: View {
    
    @State var animeResponse = AnimeResponse(results: [])
    @State private var searchTerm = ""
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(animeResponse.results, id: \.node.id) { anime in
                    NavigationLink(destination: AnimeDetailsView(anime: anime.node)) {
                        AnimeView(title: anime.node.title, image: anime.node.images.large, episodes: anime.node.episodes ?? 0, releaseYear: String(anime.node.startDate?.prefix(4) ?? "Unknown"), rating: anime.node.rating ?? 0.0, type: anime.node.mediaType ?? "Unknown")
                    }
                }
                
            }
        }
        .searchable(text: $searchTerm)
        .onSubmit(of: .search) {
            Task {
                await loadAnimePreviews(searchTerm: searchTerm)
            }
        }
        .onAppear {
            Task {
                await loadTopAnimes()
            }
        }
    }
    
    func loadTopAnimes() async {
        let baseURL = "https://api.myanimelist.net/v2/anime/ranking"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: "all"),
            URLQueryItem(name: "fields", value: "id,title,main_picture,mean,num_episodes,media_type,start_date")
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedAnimeResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
            animeResponse = decodedAnimeResponse
        } catch {
            print("error: ", error)
        }
    }
    
    func loadAnimePreviews(searchTerm: String) async {
        let baseURL = "https://api.myanimelist.net/v2/anime"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "fields", value: "id,title,main_picture,mean,num_episodes,media_type,start_date")
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedAnimeResponse = try JSONDecoder().decode(AnimeResponse.self, from: data)
            animeResponse = decodedAnimeResponse
            print(animeResponse)
        } catch {
            print("error: ", error)
        }
    }
}

#Preview {
    AnimeListView()
}
