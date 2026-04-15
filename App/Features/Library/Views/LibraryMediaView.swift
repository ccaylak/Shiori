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
    let episodeDurationInMinutes: Int
    let completed: Bool
    
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
                        let isRated = score > 0

                        Image(systemName: isRated ? "star.fill" : "star")
                            .foregroundColor(isRated ? .yellow : .secondary)
                            .font(.system(size: 14, weight: .bold))

                        Text(isRated ? "\(score)" : "?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isRated ? .primary : .secondary)
                    }
                }
                .padding(.vertical, 4)
                
                Spacer()
                    .isVisible(settingsManager.mangaFormat != .both)
                
                switch type {
                case .anime(_):
                    HStack {
                        Label(progress.totalValue > 0
                              ? "\(progress.currentValue)/\(progress.totalValue)"
                              : "\(progress.currentValue)", systemImage: "tv")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        
                        if progress.totalValue > 0 {
                            Gauge(value: Double(progress.currentValue), in: 0...Double(progress.totalValue)) {
                                if (!completed) {
                                    Text(leftTime(episodeDurationInMinutes: episodeDurationInMinutes, totalEpisodes: progress.totalValue, watchedEpisodes: progress.currentValue, includeFirstEpisodeInDuration: settingsManager.includeFirstEpisodeInDuration))
                                        .font(.caption2)
                                        .foregroundStyle(Color.secondary)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .isVisible(settingsManager.animeFormat == .episodesWithDuration)
                                }
                            }
                                .gaugeStyle(.accessoryLinearCapacity)
                        } else {
                            Gauge(value: 1, in: 0...1) { }
                                .gaugeStyle(.accessoryLinearCapacity)
                                .tint(Color.secondary)
                        }
                    }
                    
                case .manga(_):
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Label(progress.secondaryTotalValue > 0
                                  ? "\(progress.secondaryCurrentValue)/\(progress.secondaryTotalValue)"
                                  : "\(progress.secondaryCurrentValue)", systemImage: "character.book.closed.fill.ja")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            Spacer()
                            
                            let total = max(progress.secondaryTotalValue, 1)
                            let completed = min(progress.secondaryCurrentValue, total)
                            Gauge(value: Double(completed), in: 0...Double(total)) {}
                                .gaugeStyle(.accessoryLinearCapacity)
                                .tint(progress.secondaryTotalValue > 0 ? .accentColor : .secondary)
                                .frame(maxWidth: 160)
                        }
                        .isVisible(settingsManager.mangaFormat == .both || settingsManager.mangaFormat == .volume)
                        
                        HStack {
                            Label(progress.totalValue > 0
                                  ? "\(progress.currentValue)/\(progress.totalValue)"
                                  : "\(progress.currentValue)", systemImage: "book.pages.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            
                            Spacer()
                            
                            let total = max(progress.totalValue, 1)
                            let completed = min(progress.currentValue, total)
                            Gauge(value: Double(completed), in: 0...Double(total)) {}
                                .gaugeStyle(.accessoryLinearCapacity)
                                .tint(progress.totalValue > 0 ? .accentColor : .secondary)
                                .frame(maxWidth: 160)
                        }
                        .isVisible(settingsManager.mangaFormat == .both || settingsManager.mangaFormat == .chapter)
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
    
    func leftTime(
        episodeDurationInMinutes: Int,
        totalEpisodes: Int,
        watchedEpisodes: Int,
        includeFirstEpisodeInDuration: Bool
    ) -> String {
        
        let clampedWatchedEpisodes = min(max(watchedEpisodes, 0), totalEpisodes)
        
        var remainingEpisodes = totalEpisodes - clampedWatchedEpisodes
        
        if includeFirstEpisodeInDuration {
            remainingEpisodes += 1
        }
        
        let totalMinutesLeft = remainingEpisodes * episodeDurationInMinutes
        
        if totalMinutesLeft == 0 {
            return ""
        }
        
        let hours = totalMinutesLeft / 60
        let minutes = totalMinutesLeft % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
}
