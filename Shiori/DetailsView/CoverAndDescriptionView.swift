import SwiftUI

struct CoverAndDescriptionView: View {
    
    let title: String
    let imageUrl: String
    let score: Double
    let mediaCount: Int
    let description: String
    let type: String
    let mediaType: MediaType
    
    @State private var isDescriptionExpanded = false
    
    var body: some View {
        HStack (alignment: .top, spacing: 10) {
            CoverImage(
                imageUrl: imageUrl,
                score: score,
                type: type,
                mediaType: mediaType,
                mediaCount: mediaCount
            )
            VStack (alignment: .leading) {
                Text(description)
                    .lineLimit(11)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)
                Button(isDescriptionExpanded ? "Show less" : "Show more") {
                    isDescriptionExpanded.toggle()
                }
                .font(.caption)
                .sheet(isPresented: $isDescriptionExpanded) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.headline)
                                .padding(.bottom)
                            Text(description)
                                .font(.subheadline)
                            
                        }
                        .padding()
                        .presentationDetents([.large, .medium])
                        .presentationBackgroundInteraction(.automatic)
                        
                    }
                    .scrollIndicators(.automatic)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CoverImage: View {
    
    let imageUrl: String
    let score: Double
    let type: String
    let mediaType: MediaType
    let mediaCount: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImageView(imageUrl: imageUrl)
                .frame(width: 159, height: 250)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
        }
        .overlay(alignment: .topTrailing) {
            ScoreBadge(score: score)
        }
        .overlay(alignment: .bottomTrailing) {
            MediaInfoText(mediaCount: mediaCount, type: type, mediaType: mediaType)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ScoreBadge: View {
    
    let score: Double
    
    var body: some View {
        if (score >= 0 && score <= 10){
            HStack {
                Text("\(score.formatted())")
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
}

struct MediaInfoText: View {
    
    let mediaCount: Int
    let type: String
    let mediaType: MediaType
    
    var body: some View {
        if let formattedText = formatMediaInfo(type: type, count: mediaCount),
           (mediaType == .anime || mediaType == .manga) {
            Text(formattedText)
                .bold()
                .font(.title3)
                .padding(4)
                .foregroundStyle(.white)
                .background(Material.ultraThin)
                .cornerRadius(12)
        }
    }
    
    func formatMediaInfo(type: String, count: Int) -> String? {
        guard count > 0 else { return nil }
        
        switch type {
        case AnimeType.movie.rawValue where count > 1:
            return "\(count) parts"
        case AnimeType.tv.rawValue where count > 1:
            return "\(count) episodes"
        case MangaType.manga.rawValue:
            return "\(count) chapters"
        default:
            return nil
        }
    }
}



#Preview {
    CoverAndDescriptionView(
        title: "Tokyo Ghoul",
        imageUrl: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg",
        score: 10.0,
        mediaCount: 10,
        description:
"""
One year after the events at the Sanctuary, Subaru Natsuki trains hard to better face future challenges. The
peaceful days come to an end when Emilia receives an invitation to a meeting in the Watergate City of Priestella
from none other than Anastasia Hoshin, one of her rivals in the royal selection. Considering the meeting's
significance and the potential dangers Emilia could face, Subaru and his friends accompany her.

However, as Subaru reconnects with old associates and companions in Priestella, new formidable foes emerge.
Driven by fanatical motivations and engaging in ruthless methods to achieve their ambitions, the new enemy
targets Emilia and threaten the very existence of the city. Rallying his allies, Subaru must give his all once
more to stop their and nefarious goals from becoming a concrete reality.

[Written by MAL Rewrite]
""",
        type: "tv",
        mediaType: MediaType.anime
    )
}
