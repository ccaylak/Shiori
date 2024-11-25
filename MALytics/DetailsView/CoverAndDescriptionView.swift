import SwiftUI

struct CoverAndDescriptionView: View {
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    
    let title: String
    let imageUrl: String
    let rating: Double
    let mediaCount: Int
    let description: String
    let typeString: String
    
    private var animeType: AnimeType {
        AnimeType(rawValue: typeString) ?? .unknown
    }
    
    private var mangaType: MangaType {
        MangaType(rawValue: typeString) ?? .unknown
    }
    
    @State private var isDescriptionExpanded = false
    
    var body: some View {
        HStack (alignment: .top, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                AsyncImageView(imageUrl: imageUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cornerRadius(12)
            }
            .overlay(alignment: .topTrailing) {
                if (rating != 0.0){
                    HStack {
                        Text("\(rating.formatted())")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Image(systemName: "star.fill")
                            .foregroundStyle(.white)
                    }
                    .padding(4)
                    .background(Material.ultraThin)
                    .cornerRadius(12)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if (formatTypeAndEpisodes(type: animeType, episodes: mediaCount) != nil && mediaType == .anime) {
                    Text(formatTypeAndEpisodes(type: animeType, episodes: mediaCount)!)
                        .bold()
                        .font(.title3)
                        .padding(4)
                        .foregroundStyle(.white)
                        .background(Material.ultraThin)
                        .cornerRadius(12)
                }
                if (formatTypeAndChapters(type: mangaType, chapters: mediaCount) != nil  && mediaType == .manga) {
                    Text(formatTypeAndChapters(type: mangaType, chapters: mediaCount)!)
                        .bold()
                        .font(.title3)
                        .padding(4)
                        .foregroundStyle(.white)
                        .background(Material.ultraThin)
                        .cornerRadius(12)
                }
                
            }
            .cornerRadius(12)
            .frame(maxWidth: .infinity)
            
            VStack (alignment: .leading) {
                Text(description)
                    .lineLimit(10)
                    .font(.subheadline)
                    .truncationMode(.tail)
                Button(isDescriptionExpanded ? "Show less" : "Show more") {
                    isDescriptionExpanded.toggle()
                }
                .font(.caption)
                .sheet(isPresented: $isDescriptionExpanded) {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            Text(title)
                                .font(.headline)
                                .padding(.bottom)
                            Text(description)
                                .font(.subheadline)
                            
                        }
                    }
                    .padding()
                    
                }
            }.frame(maxWidth: .infinity)
        }
    }
    
    func formatTypeAndEpisodes(type: AnimeType, episodes: Int) -> String? {
        if (episodes > 1 && type == .movie) {
            return "\(episodes) parts"
        }
        
        if (episodes > 1 && type == .tv) {
            return "\(episodes) episodes"
        }

        return nil
    }
    
    func formatTypeAndChapters(type: MangaType, chapters: Int) -> String? {
        if (chapters > 0) {
            return "\(chapters) chapters"
        }
        
        return nil
    }
}

#Preview {
    CoverAndDescriptionView(
        title: "Tokyo Ghoul",
        imageUrl: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg",
        rating: 10.0,
        mediaCount: 10,
        description: """
        One year after the events at the Sanctuary, Subaru Natsuki trains hard to better face future challenges. The peaceful days come to an end when Emilia receives an invitation to a meeting in the Watergate City of Priestella from none other than Anastasia Hoshin, one of her rivals in the royal selection. Considering the meeting's significance and the potential dangers Emilia could face, Subaru and his friends accompany her.

        However, as Subaru reconnects with old associates and companions in Priestella, new formidable foes emerge. Driven by fanatical motivations and engaging in ruthless methods to achieve their ambitions, the new enemy targets Emilia and threaten the very existence of the city. Rallying his allies, Subaru must give his all once more to stop their and nefarious goals from becoming a concrete reality.

        [Written by MAL Rewrite]
""",
        typeString: "tv"
    )
}
