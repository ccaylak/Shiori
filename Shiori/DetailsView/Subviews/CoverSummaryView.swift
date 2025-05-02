import SwiftUI

struct CoverSummaryView: View {
    
    let title: String
    let imageUrl: String
    let score: Double
    let chapters: Int
    let volumes: Int
    let episodes: Int
    let summary: String
    let type: FormatType
    
    var body: some View {
        HStack (alignment: .top, spacing: 10) {
            CoverView(imageUrl: imageUrl, score: score, type: type, chapters: chapters, volumes: volumes, episodes: episodes)
            SummaryView(summary: summary, title: title)
        }
    }
}

private struct CoverView: View {
    
    let imageUrl: String
    let score: Double
    let type: FormatType
    let chapters: Int
    let volumes: Int
    let episodes: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImageView(imageUrl: imageUrl)
                .frame(width: 159, height: 250)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
        }
        .overlay(alignment: .topTrailing) {
            ScoreBadgeView(score: score)
        }
        .overlay(alignment: .bottomTrailing) {
            CountBadgeView(chapters: chapters, volumes: volumes,episodes: episodes, type: type)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SummaryView: View {
    
    let summary: String
    let title: String
    
    @State private var isDescriptionExpanded: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(summary)
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
                        Text(summary)
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

private struct ScoreBadgeView: View {
    let score: Double
    
    var body: some View {
        if (score > 0 && score <= 10){
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

private struct CountBadgeView: View {
    let chapters: Int
    let volumes: Int
    let episodes: Int
    let type: FormatType
    
    var body: some View {
        if let formattedText = formatMediaInfo(type: type, episodes: episodes, chapters: chapters, volumes: volumes) {
            Text(formattedText)
                .bold()
                .font(.title3)
                .padding(4)
                .foregroundStyle(.white)
                .background(Material.ultraThin)
                .cornerRadius(12)
        }
    }
    
    func formatMediaInfo(type: FormatType, episodes: Int, chapters: Int, volumes: Int) -> String? {
        
        switch type {
        case .anime(let animeType):
            switch animeType {
            case .movie where episodes > 1:
                return String(localized: "\(episodes) parts")
            case .tv where episodes > 1,
                    .ova where episodes > 1,
                    .tvSpecial where episodes > 1,
                    .special where episodes > 1:
                return String(localized: "\(episodes) episodes")
            default:
                return nil
            }
            
        case .manga(let mangaType):
            switch mangaType {
            case .manga where chapters > 1, .lightNovel where chapters > 1, .manhwa where chapters > 1, .manhua where chapters > 1, .doujinshi where chapters > 1:
                return String(localized: "\(chapters) chapters")
            case .manga where chapters == 0 && volumes > 1, .doujinshi where chapters == 0 && volumes > 1:
                return String(localized: "\(volumes) volumes")
            default:
                return nil
            }
        }
    }
}



#Preview {
    CoverSummaryView(
        title: "Tokyo Ghoul",
        imageUrl: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg",
        score: 10.0,
        chapters: 10,
        volumes: 100,
        episodes: 0,
        summary:
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
        type: .anime(.tv),
    )
}
