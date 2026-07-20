import SwiftUI
import SwiftData

struct LibraryMediaView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var upcomingSchedule: AnimeSchedule?

    @Environment(AppSettings.self)
    private var settings
    
    @Environment(\.colorScheme) private var colorScheme
    
    let malId: Int
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
                    .lineLimit(1)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, upcomingSchedule == nil ? 0 : 105)
                
                Text(formattedDetails(year: release))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    HStack(spacing: 4) {
                        let isRated = score > 0

                        Image(systemName: isRated ? "star.fill" : "star")
                            .foregroundColor(isRated ? .yellow : .secondary)
                            .font(.system(size: 14, weight: .bold))

                        Group {
                            if isRated {
                                Text(score,format: .number)
                            } else {
                                Text(verbatim: "?")
                            }
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(isRated ? Color.primary : Color.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                Spacer()
                    .isVisible(settings.mangaFormat != .both)
                
                switch type {
                case .anime(_):
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Label {
                                Text(
                                    verbatim: progress.totalValue > 0
                                        ? "\(progress.currentValue)/\(progress.totalValue)"
                                        : "\(progress.currentValue)"
                                )
                            } icon: {
                                Image(systemName: "tv")
                            }                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                            .fontWeight(.semibold)

                            if progress.totalValue > 0 {
                                Gauge(value: Double(progress.currentValue), in: 0...Double(progress.totalValue)) {
                                    if !completed {
                                        Text(leftTime(episodeDurationInMinutes: episodeDurationInMinutes,
                                                totalEpisodes: progress.totalValue,
                                                watchedEpisodes: progress.currentValue,
                                                includeFirstEpisodeInDuration:
                                                    settings.includeFirstEpisodeInDuration
                                            )
                                        )
                                        .font(.caption2)
                                        .foregroundStyle(Color.secondary)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .isVisible(
                                            settings.animeFormat == .episodesWithDuration
                                        )
                                    }
                                }
                                .gaugeStyle(.accessoryLinearCapacity)
                            } else {
                                Gauge(value: 1, in: 0...1) { }
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .tint(Color.secondary)
                            }
                        }
                    }
//                case .anime(_):
//                    HStack {
//                        Label(progress.totalValue > 0
//                              ? "\(progress.currentValue)/\(progress.totalValue)"
//                              : "\(progress.currentValue)", systemImage: "tv")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .fontWeight(.semibold)
//                        
//                        if progress.totalValue > 0 {
//                            Gauge(value: Double(progress.currentValue), in: 0...Double(progress.totalValue)) {
//                                if (!completed) {
//                                    Text(leftTime(episodeDurationInMinutes: episodeDurationInMinutes, totalEpisodes: progress.totalValue, watchedEpisodes: progress.currentValue, includeFirstEpisodeInDuration: settings.includeFirstEpisodeInDuration))
//                                        .font(.caption2)
//                                        .foregroundStyle(Color.secondary)
//                                        .bold()
//                                        .frame(maxWidth: .infinity, alignment: .center)
//                                        .isVisible(settings.animeFormat == .episodesWithDuration)
//                                }
//                            }
//                                .gaugeStyle(.accessoryLinearCapacity)
//                        } else {
//                            Gauge(value: 1, in: 0...1) { }
//                                .gaugeStyle(.accessoryLinearCapacity)
//                                .tint(Color.secondary)
//                        }
//                    }
                    
                case .manga(_):
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Label {
                                Text(
                                    verbatim: progress.secondaryTotalValue > 0
                                        ? "\(progress.secondaryCurrentValue)/\(progress.secondaryTotalValue)"
                                        : "\(progress.secondaryCurrentValue)"
                                )
                            } icon: {
                                Image(systemName: "character.book.closed.fill.ja")
                            }
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
                        .isVisible(settings.mangaFormat == .both || settings.mangaFormat == .volume)
                        
                        HStack {
                            Label {
                                Text(
                                    verbatim: progress.totalValue > 0
                                        ? "\(progress.currentValue)/\(progress.totalValue)"
                                        : "\(progress.currentValue)"
                                )
                            } icon: {
                                Image(systemName: "book.pages.fill")
                            }
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
                        .isVisible(settings.mangaFormat == .both || settings.mangaFormat == .chapter)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            if case .anime = type,
               let upcomingSchedule {

                VStack(spacing: 0) {
                    Text("Episode \(upcomingSchedule.episodeNumber)")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.tint)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)

                    Divider()
                        .overlay(Color.accentColor.opacity(0.15))

                    Text(verbatim: {
                        let airingAt = upcomingSchedule.airingAt
                        let calendar = Calendar.current

                        let time: String = {
                            switch settings.airingNotificationTimeFormat {
                            case .twelveHour:
                                airingAt.formatted(
                                    .dateTime
                                        .hour(.defaultDigits(amPM: .abbreviated))
                                        .minute(.twoDigits)
                                        .locale(Locale(identifier: "en_US"))
                                )

                            case .twentyFourHour:
                                airingAt.formatted(
                                    .dateTime
                                        .hour(.twoDigits(amPM: .omitted))
                                        .minute(.twoDigits)
                                        .locale(Locale(identifier: "de_DE"))
                                )
                            }
                        }()

                        if calendar.isDateInToday(airingAt) {
                            return "\(String(localized: "Today")), \(time)"
                        }

                        if calendar.isDateInTomorrow(airingAt) {
                            return "\(String(localized: "Tomorrow")), \(time)"
                        }

                        let daysUntilAiring = calendar.dateComponents(
                            [.day],
                            from: calendar.startOfDay(for: .now),
                            to: calendar.startOfDay(for: airingAt)
                        ).day ?? 0

                        if daysUntilAiring < 7 {
                            let weekday = airingAt.formatted(
                                .dateTime.weekday(.abbreviated)
                            )

                            return "\(weekday), \(time)"
                        }

                        let date = airingAt.formatted(
                            .dateTime
                                .day(.twoDigits)
                                .month(.twoDigits)
                        )

                        return "\(date), \(time)"
                    }())
                    .lineLimit(1)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tint)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .background(
                    Color.accentColor.opacity(0.1),
                    in: RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                )
                .fixedSize()
            }
        }
        .onAppear {
            do {
                let schedules = try modelContext.fetch(
                    FetchDescriptor<AnimeSchedule>()
                )

                upcomingSchedule = schedules
                    .filter {
                        $0.malId == malId &&
                        $0.airingAt > Date()
                    }
                    .sorted {
                        $0.airingAt < $1.airingAt
                    }
                    .first
            } catch {
                print("Failed to fetch schedules:", error)
            }
        }
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
