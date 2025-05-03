import SwiftUI

struct MediaView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let image: String
    let releaseYear: String
    let type: FormatType
    let mediaCount: Int
    let status: Status
    
    private var isDarkMode: Bool {
        if settingsManager.appearance == .system {
            return colorScheme == .dark
        }
        return settingsManager.appearance == .dark
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
                .frame(width: 70, height: 110)
                .clipped()
                .cornerRadius(12)
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
                .fill(isDarkMode ? Color.gray.opacity(0.15) : Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
    }
    
    func formattedDetails(year: String) -> String {
        var formattedResult = ""
        
        switch type {
        case .anime(let animeType):
            formattedResult = formattedAnimeDetails(type: animeType, year: year)
        case .manga(let mangaType):
            formattedResult = formattedMangaDetails(type: mangaType, year: year)
        }
        
        return formattedResult
    }
    
    func formattedAnimeDetails(type: FormatType.Anime, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedMangaDetails(type: FormatType.Manga, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedOtherDetails(year: String) -> String {
        switch (type, status) {
        case (.anime(let animeType), .anime(let animeStatus)):
            return formattedOtherAnimeDetails(
                episodes: mediaCount,
                status: animeStatus,
                type: animeType
            )

        case (.manga(let mangaType), .manga(let mangaStatus)):
            return formattedOtherMangaDetails(
                chapters: mediaCount,
                status: mangaStatus,
                type: mangaType
            )

        default:
            return ""
        }
    }
    
    func formattedOtherAnimeDetails(episodes: Int, status: Status.Anime, type: FormatType.Anime) -> String {
        
        if episodes == 0 && (status == .notYetAired || status == .currentlyAiring) {
            return status.displayName
        }
        
        if type == .movie {
            return episodes > 1 ? String(localized: "\(episodes) parts") : ""
        }
        
        if type == .tvSpecial || type == .special {
            return episodes > 1 ? String(localized: "\(episodes) episodes") : ""
        }
        
        return String(localized: "\(episodes) episodes (\(status.displayName))")
    }
    
    func formattedOtherMangaDetails(chapters: Int, status: Status.Manga, type: FormatType.Manga) -> String {
        if(status == .currentlyPublishing) {
            return status.displayName
        }
        if (chapters == 0 && status == .finished) {
            return status.displayName
        }
        return String(localized: "\(chapters) chapters (\(status.displayName))")
    }
}

#Preview {
    MediaView(
        title: "Tokyo Ghoul",
        image: "https://cdn.myanimelist.net/images/manga/3/145997l.jpg",
        releaseYear: "2021",
        type: .anime(.tv),
        mediaCount: 12,
        status: .anime(.currentlyAiring)
    )
}
