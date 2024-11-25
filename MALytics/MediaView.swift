import SwiftUI

struct MediaView: View {
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    
    let title: String
    let image: String
    let releaseYear: String
    let typeString: String
    let statusString: String
    let episodes: Int
    let numberOfVolumes: Int
    let numberOfChapters: Int
    let authors: [AuthorInfos]
    
    private var animeType: AnimeType {
        AnimeType(rawValue: typeString) ?? .unknown
    }
    
    private var animeStatus: AnimeStatus {
        AnimeStatus(rawValue: statusString) ?? .unknown
    }
    
    private var mangaType: MangaType {
        MangaType(rawValue: typeString) ?? .unknown
    }
    
    private var mangaStatus: MangaStatus {
        MangaStatus(rawValue: statusString) ?? .unknown
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 5) {
                if (mediaType == .anime) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                if (mediaType == .manga) {
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                }
                
                if(mediaType == .anime) {
                    Text(formatTypeAndReleaseYear(type: animeType, releaseYear: releaseYear))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if(mediaType == .manga) {
                    Text(formatMangaAndReleaseYear(type: mangaType, releaseYear: releaseYear))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if (mediaType == .anime) {
                    Text(formattedEpisodesWithStatus(episodes: episodes, status: animeStatus, type: animeType))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if (mediaType == .manga) {
                    Text(formattedChaptersWithStatus(chapters: numberOfChapters, status: mangaStatus, type: mangaType))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    func formatTypeAndReleaseYear(type: AnimeType, releaseYear: String) -> String {
        
        if(type == .unknown && releaseYear == "Unknown") {
            return ""
        }
        
        if (type != .unknown && releaseYear == "Unknown") {
            return type.displayName
        }
        
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formatMangaAndReleaseYear(type: MangaType, releaseYear: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedEpisodesWithStatus(episodes: Int, status: AnimeStatus, type: AnimeType) -> String {
        if(episodes == 0 && (status == .notYetAired || status == .currentlyAiring)) {
            return status.displayName
        }
        if (type == .movie) {
            if (episodes > 1) {
                return "\(episodes) parts"
            }
            return ""
        }
        if (type == .tvSpecial || type == .special) {
            if (episodes > 1) {
                return "\(episodes) episodes"
            }
            return ""
        }
        
        return "\(episodes) episodes (\(status.displayName))"
    }
    
    func formattedChaptersWithStatus(chapters: Int, status: MangaStatus, type: MangaType) -> String {
        if(status == .currentlyPublishing) {
            return status.displayName
        }
        if (chapters == 0 && status == .finished) {
            return status.displayName
        }
        return "\(chapters) chapters (\(status.displayName))"
    }
}

#Preview {
    MediaView(
        title: "Tokyo Ghoul",
        image: "https://cdn.myanimelist.net/images/manga/3/145997l.jpg",
        releaseYear: "2021",
        typeString: "tv",
        statusString: "finished_airing",
        episodes: 12,
        numberOfVolumes: 100,
        numberOfChapters: 700,
        authors: [
            AuthorInfos(
                author: AuthorInfos.Author(
                    id:1,
                    firstName: "Sui",
                    lastName: "Ishida"
                ),
                role: "Writer"
            )
        ]
    )
}
