import SwiftUI

struct MediaView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let image: String
    let releaseYear: String
    let type: MediaType
    let mediaCount: Int
    let status: Status
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
                .frame(width: CoverSize.small.size.width, height: CoverSize.small.size.height)
                .clipped()
                .cornerRadius(12)
                .strokedBorder()
            
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
            .frame(maxWidth: .infinity, maxHeight: CoverSize.small.size.height, alignment: .leading)
        
        }
        .frame(maxWidth: .infinity, maxHeight: CoverSize.small.size.height, alignment: .leading)
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
    
    func formattedAnimeDetails(type: MediaType.Anime, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedMangaDetails(type: MediaType.Manga, year: String) -> String {
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
    
    func formattedOtherAnimeDetails(episodes: Int, status: Status.Anime, type: MediaType.Anime) -> String {
        
        if episodes == 0 && (status == .notYetAired || status == .currentlyAiring) {
            return status.displayName
        }
        
        if type == .movie {
            return episodes > 1 ? String(localized: "\(episodes) Parts") : ""
        }
        
        if type == .tvSpecial || type == .special {
            return episodes > 1 ? String(localized: "\(episodes) Episodes") : ""
        }
        
        return String(localized: "\(episodes) Episodes (\(status.displayName))")
    }
    
    func formattedOtherMangaDetails(chapters: Int, status: Status.Manga, type: MediaType.Manga) -> String {
        if(status == .currentlyPublishing) {
            return status.displayName
        }
        if (chapters == 0 && status == .finished) {
            return status.displayName
        }
        return String(localized: "\(chapters) Chapters (\(status.displayName))")
    }
}
