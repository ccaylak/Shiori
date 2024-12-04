import SwiftUI

struct MediaView: View {
    
    @AppStorage("appearance") private var appearance = Appearance.light
    
    let title: String
    let image: String
    let releaseYear: String
    let type: String
    let status: String
    let mediaCount: Int
    
    var statusType: Any? {
        if let mangaStatus = MangaStatus(rawValue: status) {
            return mangaStatus
        } else if let animeStatus = AnimeStatus(rawValue: status) {
            return animeStatus
        }
        
        return nil
    }
    
    var mediaType: Any? {
        if let mangaType = MangaType(rawValue: type) {
            return mangaType
        } else if let animeType = AnimeType(rawValue: type) {
            return animeType
        }
        
        return nil
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .lineLimit(3)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Text(formattedDetails(year: releaseYear))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                
                Text(formattedOtherDetails(year: releaseYear))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((appearance == .dark) ? Color.gray.opacity(0.15) : Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    func formattedDetails(year: String) -> String {
        var formattedResult = ""
        if mediaType is MangaType{
            formattedResult = formattedMangaDetails(type: mediaType as! MangaType, year: year)
        } else if mediaType is AnimeType {
            formattedResult = formattedAnimeDetails(type: mediaType as! AnimeType, year: year)
        }
        return formattedResult
    }
    
    func formattedAnimeDetails(type: AnimeType, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedMangaDetails(type: MangaType, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedOtherDetails(year: String) -> String {
        var formattedResult = ""
        if mediaType is MangaType && statusType is MangaStatus{
            formattedResult = formattedOtherMangaDetails(chapters: mediaCount, status: statusType as! MangaStatus, type: mediaType as! MangaType)
        } else if mediaType is AnimeType && statusType is AnimeStatus {
            formattedResult = formattedOtherAnimeDetails(episodes: mediaCount, status: statusType as! AnimeStatus, type: mediaType as! AnimeType)
        }
        return formattedResult
    }
    
    func formattedOtherAnimeDetails(episodes: Int, status: AnimeStatus, type: AnimeType) -> String {
        
        if episodes == 0 && (status == .notYetAired || status == .currentlyAiring) {
            return status.displayName
        }

        if type == .movie {
            return episodes > 1 ? "\(episodes) parts" : ""
        }

        if type == .tvSpecial || type == .special {
            return episodes > 1 ? "\(episodes) episodes" : ""
        }
        
        return "\(episodes) episodes (\(status.displayName))"
    }
    
    func formattedOtherMangaDetails(chapters: Int, status: MangaStatus, type: MangaType) -> String {
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
        type: "tv",
        status: "finished_airing",
        mediaCount: 12
    )
}
