import SwiftUI

struct LibraryMediaView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let image: String
    let releaseYear: String
    let type: FormatType
    let rating: Int
    let completedUnits: Int
    let totalUnits: Int
    
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
                
                Spacer()
                HStack {
                    let icon = {
                        if case .manga = type { return "character.book.closed.fill.ja" }
                        else { return "tv" }
                    }()
                    
                    Label(totalUnits > 0
                          ? "\(completedUnits)/\(totalUnits)"
                          : "\(completedUnits)", systemImage: icon)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                    
                    if totalUnits > 0 {
                        Gauge(value: Double(completedUnits), in: 0...Double(totalUnits)) { }
                            .gaugeStyle(.accessoryLinearCapacity)
                    } else {
                        Gauge(value: 1, in: 0...1) { }
                            .gaugeStyle(.accessoryLinearCapacity)
                            .tint(Color.secondary)
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
        completedUnits: 5,
        totalUnits: 0
    )
}
