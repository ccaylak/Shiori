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
                
                
                HStack(alignment: .center, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14, weight: .bold))
                        Text("\(rating)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 4)
                
                
                let clampedCompletedUnits = min(max(Double(completedUnits), 1), Double(totalUnits > 0 ? totalUnits : 1))
                
                Gauge(value: clampedCompletedUnits, in: 1...Double(totalUnits > 0 ? totalUnits : 1)) {
                } currentValueLabel: {
                    Text("\(completedUnits)")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text(totalUnits == 0 ? "?" : "\(totalUnits)")
                }
                .gaugeStyle(.accessoryLinear)
                
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
