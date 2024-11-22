import SwiftUI

struct MangaListView: View {
    
    @State var mangaResponse = MangaResponse(results: [])
    @State private var searchTerm = ""
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(mangaResponse.results, id: \.node.id) { manga in
                    Text(manga.node.title)
                }
                
            }
        }
        .searchable(text: $searchTerm)
        .onSubmit(of: .search) {
            Task {
                await loadMangaPreviews(searchTerm: searchTerm)
            }
        }
        .onAppear {
            Task {
                await loadTopMangas()
            }
        }
    }
    
    func loadTopMangas() async {
        let baseURL = "https://api.myanimelist.net/v2/manga/ranking"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "ranking_type", value: "all")
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedMangaResponse = try JSONDecoder().decode(MangaResponse.self, from: data)
            mangaResponse = decodedMangaResponse
        } catch {
            print("error: ", error)
        }
    }
    
    func loadMangaPreviews(searchTerm: String) async {
        let baseURL = "https://api.myanimelist.net/v2/anime"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "q", value: searchTerm)
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.apiKey, forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedMangaResponse = try JSONDecoder().decode(MangaResponse.self, from: data)
            mangaResponse = decodedMangaResponse
        } catch {
            print("error: ", error)
        }
    }
}

#Preview {
    MangaListView()
}
