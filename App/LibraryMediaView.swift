import SwiftUI

struct LibraryMediaView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let image: String
    let releaseYear: String
    let type: FormatType
    let rating: Int
    
    let completedEpisodes: Int?
    let totalEpisodes: Int?
    
    let completedChapters: Int?
    let totalChapters: Int?
    let completedVolumes: Int?
    let totalVolumes: Int?
    
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
                
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    HStack(spacing: 4) {
                        if rating > 1 {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 14, weight: .bold))
                            
                            Text("\(rating)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        else {
                            Image(systemName: "star")
                                .foregroundColor(Color.secondary)
                                .font(.system(size: 14, weight: .bold))
                            
                            Text("?")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
                
                if(settingsManager.mangaMode != .all) {
                    Spacer()
                }
                switch type {
                case .anime(_):
                    HStack {
                        Label(totalEpisodes ?? 0 > 0
                              ? "\(completedEpisodes ?? 0)/\(totalEpisodes ?? 0)"
                              : "\(completedEpisodes ?? 0)", systemImage: "tv")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        
                        if totalEpisodes ?? 0 > 0 {
                            Gauge(value: Double(completedEpisodes ?? 0), in: 0...Double(totalEpisodes!)) { }
                                .gaugeStyle(.accessoryLinearCapacity)
                        } else {
                            Gauge(value: 1, in: 0...1) { }
                                .gaugeStyle(.accessoryLinearCapacity)
                                .tint(Color.secondary)
                        }
                    }
                    
                case .manga(_):
                    if (settingsManager.mangaMode == .all) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Label(totalVolumes ?? 0 > 0
                                      ? "\(completedVolumes ?? 0)/\(totalVolumes ?? 0)"
                                      : "\(completedVolumes ?? 0)", systemImage: "character.book.closed.fill.ja")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                Spacer()
                                
                                let total = max(totalVolumes ?? 0, 1)
                                let completed = min(completedVolumes ?? 0, total)
                                Gauge(value: Double(completed), in: 0...Double(total)) {}
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(totalVolumes ?? 0 > 0 ? .accentColor : .secondary)
                                    .frame(maxWidth: 160)
                            }
                            
                            HStack {
                                Label(totalChapters ?? 0 > 0
                                      ? "\(completedChapters ?? 0)/\(totalChapters ?? 0)"
                                      : "\(completedChapters ?? 0)", systemImage: "book.pages.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                
                                Spacer()
                                let total = max(totalChapters ?? 0, 1)
                                let completed = min(completedChapters ?? 0, total)
                                Gauge(value: Double(completed), in: 0...Double(total)) {}
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(totalChapters ?? 0 > 0 ? .accentColor : .secondary)
                                    .frame(maxWidth: 160)
                            }
                        }
                    }
                    
                    if (settingsManager.mangaMode == .volume) {
                        HStack {
                            Label(totalVolumes ?? 0 > 0
                                  ? "\(completedVolumes ?? 0)/\(totalVolumes ?? 0)"
                                  : "\(completedVolumes ?? 0)", systemImage: "character.book.closed.fill.ja")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            
                            if totalVolumes ?? 0 > 0 {
                                Gauge(value: Double(completedVolumes ?? 0), in: 0...Double(totalVolumes ?? 0)) { }
                                    .gaugeStyle(.accessoryLinearCapacity)
                            } else {
                                Gauge(value: 1, in: 0...1) { }
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(Color.secondary)
                            }
                        }
                    }
                    if (settingsManager.mangaMode == .chapter) {
                        HStack {
                            Label(totalChapters ?? 0 > 0
                                  ? "\(completedChapters ?? 0)/\(totalChapters ?? 0)"
                                  : "\(completedChapters ?? 0)", systemImage: "book.pages.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            
                            if totalChapters ?? 0 > 0 {
                                Gauge(value: Double(completedChapters ?? 0), in: 0...Double(totalChapters ?? 0)) { }
                                    .gaugeStyle(.accessoryLinearCapacity)
                            } else {
                                Gauge(value: 1, in: 0...1) { }
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(Color.secondary)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
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
}

#Preview {
    LibraryMediaView(
        title: "Tokyo Ghoul",
        image: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg",
        releaseYear: "2020-01-01",
        type: .manga(.manga),
        rating: 4,
        completedEpisodes: 5,
        totalEpisodes: 12,
        completedChapters: nil,
        totalChapters: nil,
        completedVolumes: nil,
        totalVolumes: nil
    )
}
