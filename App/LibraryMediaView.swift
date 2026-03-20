import SwiftUI

struct LibraryMediaView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String
    let image: String
    let release: String
    let type: MediaType
    let score: Int
    let progress: LibraryMediaProgress
    
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
                
                Text(formattedDetails(year: release))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    HStack(spacing: 4) {
                        if score > 1 {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 14, weight: .bold))
                            
                            Text("\(score)")
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
                        Label(progress.total ?? 0 > 0
                              ? "\(progress.current ?? 0)/\(progress.total ?? 0)"
                              : "\(progress.current ?? 0)", systemImage: "tv")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        
                        if progress.total ?? 0 > 0 {
                            Gauge(value: Double(progress.current ?? 0), in: 0...Double(progress.total!)) { }
                                .gaugeStyle(.accessoryLinearCapacity)
                        } else {
                            Gauge(value: 1, in: 0...1) { }
                                .gaugeStyle(.accessoryLinearCapacity)
                                .tint(Color.secondary)
                        }
                    }
                    
                case .manga(_):
                    if (settingsManager.mangaMode == .all || settingsManager.mangaMode == .chapter) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Label(progress.total ?? 0 > 0
                                      ? "\(progress.current ?? 0)/\(progress.total ?? 0)"
                                      : "\(progress.current ?? 0)", systemImage: "book.pages.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                
                                Spacer()
                                let total = max(progress.total ?? 0, 1)
                                let completed = min(progress.current ?? 0, total)
                                Gauge(value: Double(completed), in: 0...Double(total)) {}
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(progress.total ?? 0 > 0 ? .accentColor : .secondary)
                                    .frame(maxWidth: 160)
                            }
                            HStack {
                                Label(progress.secondaryTotal ?? 0 > 0
                                      ? "\(progress.secondaryCurrent ?? 0)/\(progress.secondaryTotal ?? 0)"
                                      : "\(progress.secondaryCurrent ?? 0)", systemImage: "character.book.closed.fill.ja")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                Spacer()
                                
                                let total = max(progress.secondaryTotal ?? 0, 1)
                                let completed = min(progress.secondaryCurrent ?? 0, total)
                                Gauge(value: Double(completed), in: 0...Double(total)) {}
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(progress.secondaryTotal ?? 0 > 0 ? .accentColor : .secondary)
                                    .frame(maxWidth: 160)
                            }
                        }
                    }
                    
                    if (settingsManager.mangaMode == .all || settingsManager.mangaMode == .volume) {
                        HStack {
                            Label(progress.secondaryTotal ?? 0 > 0
                                  ? "\(progress.secondaryCurrent ?? 0)/\(progress.secondaryTotal ?? 0)"
                                  : "\(progress.secondaryCurrent ?? 0)", systemImage: "character.book.closed.fill.ja")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            
                            if progress.secondaryTotal ?? 0 > 0 {
                                Gauge(value: Double(progress.secondaryCurrent ?? 0), in: 0...Double(progress.secondaryTotal ?? 0)) { }
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
        return "\(type.displayName), \(release)"
    }
    
    func formattedMangaDetails(type: MediaType.Manga, year: String) -> String {
        return "\(type.displayName), \(release)"
    }
}
