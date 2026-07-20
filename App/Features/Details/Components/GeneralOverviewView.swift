import SwiftUI

struct GeneralOverviewView: View {
    @Environment(AppSettings.self)
    private var settings
    
    let type: MediaType
    let episodes: Int
    let minutes: Int
    let numberOfChapters: Int
    let numberOfVolumes: Int
    let startDate: Date?
    let endDate: Date?
    let studios: [Studio]
    let authors: [Author]
    let status: Status
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("General information")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDetails(chapters: numberOfChapters, volumes: numberOfVolumes, episodes: episodes, minutes: minutes))
                    .font(.body)
                
                Text(formattedRelease(startDate: startDate, endDate: endDate))
                    .font(.body)
                
                StudioInfoView(studios: studios, isExtendedDataEnabled: settings.isExtendedDataEnabled)
                AuthorsView(authors: authors)
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    func formattedDetails(chapters: Int, volumes: Int, episodes: Int, minutes: Int) -> String {
        switch type {
        case .manga(let manga):
            return formattedMangaDetails(type: manga, chapters: chapters, volumes: volumes)
        case .anime(let anime):
            return formattedAnimeDetails(type: anime, episodes: episodes, minutes: minutes)
        }
    }
    
    private func formattedAnimeDetails(
        type: MediaType.Anime,
        episodes: Int,
        minutes: Int
    ) -> String {
        guard episodes > 0 else {
            return type.displayName
        }

        let countText: String

        switch type {
        case .movie:
            countText = String(localized: "\(episodes) Parts")

        case .tv, .special, .tvSpecial, .ona, .ova:
            countText = String(localized: "\(episodes) Episodes")

        default:
            return type.displayName
        }

        let runtimeText = formattedDuration(from: minutes)
        let details = "\(type.displayName), \(countText) • \(runtimeText)"

        guard episodes > 1 else {
            return details
        }

        let totalDuration = formattedDuration(
            from: episodes * minutes
        )

        return "\(details) (≈\(totalDuration))"
    }
    
    private func formattedDuration(from totalMinutes: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated

        return formatter.string(
            from: TimeInterval(totalMinutes * 60)
        ) ?? ""
    }
    
    private func formattedMangaDetails(type: MediaType.Manga, chapters: Int, volumes: Int) -> String {
        
        switch (chapters, volumes) {
        case (let chapters, let volumes) where chapters > 0 && volumes > 0:
            return String(localized: "\(type.displayName), \(chapters) Chapters in \(volumes) Volumes")
        case (let chapters, 0) where chapters > 0:
            return String(localized: "\(type.displayName), \(chapters) Chapters")
        default:
            return type.displayName
        }
        
    }
    
    func formattedRelease(startDate: Date?, endDate: Date?) -> String {
        
        switch status {
        case .anime(let animeStatus): return formatReleaseRange(startDate: startDate, endDate: endDate, status: animeStatus)
        case .manga(let mangaStatus): return formatPublishRange(startDate: startDate, endDate: endDate, status: mangaStatus)
        case .unknown:
            return ""
        }
    }
    
    private func formatReleaseRange(startDate: Date?, endDate: Date?, status: Status.Anime) -> String {
        let monthYearFormat = Date.FormatStyle()
            .month(.wide)
            .year()

        switch (status, startDate, endDate) {
        case (.finishedAiring, let start?, let end?)
            where Calendar.current.isDate(start, equalTo: end, toGranularity: .month):

            return String(localized: "Aired in \(start.formatted(monthYearFormat))")

        case (.finishedAiring, let start?, let end?):
            return String(localized: "Aired from \(start.formatted(monthYearFormat)) – \(end.formatted(monthYearFormat))")

        case (.currentlyAiring, let start?, _):
            return String(localized: "Airing since \(start.formatted(monthYearFormat))")

        case (.notYetAired, let start?, _):
            return String(localized: "Will air in \(start.formatted(monthYearFormat))")

        default:
            return String(localized: "Unknown airing date")
        }
    }
    
    private func formatPublishRange(startDate: Date?, endDate: Date?, status: Status.Manga) -> String {
        let monthYearFormat = Date.FormatStyle()
            .month(.wide)
            .year()

        switch (status, startDate, endDate) {
        case (.finished, let start?, let end?)
            where Calendar.current.isDate(
                start,
                equalTo: end,
                toGranularity: .month
            ):

            return String(localized: "Published in \(start.formatted(monthYearFormat))")

        case (.finished, let start?, let end?):
            return String(localized: "Published from \(start.formatted(monthYearFormat)) - \(end.formatted(monthYearFormat))")

        case (.currentlyPublishing, let start?, _):
            return String(localized: "Publishing since \(start.formatted(monthYearFormat))")

        case (.notYetPublished, let start?, _):
            return String(localized: "Will publish in \(start.formatted(monthYearFormat))")

        case (.discontinued, let start?, let end?),
             (.onHiatus, let start?, let end?):

            return String(localized: "Published from \(start.formatted(monthYearFormat)) - \(end.formatted(monthYearFormat))")

        case (.discontinued, let start?, nil),
             (.onHiatus, let start?, nil):

            return String(localized: "Published from \(start.formatted(monthYearFormat)) - \(String(localized: "Unknown"))")

        default:
            return String(localized: "Unknown publishing date")
        }
    }
}

private struct StudioInfoView: View {
    let studios: [Studio]
    let isExtendedDataEnabled: Bool
    
    var body: some View {
        if (!studios.isEmpty) {
            Spacer()
            HStack(spacing: 5) {
                Text("Animated by")
                    
                ForEach(studios, id: \.id) {studio in
                    if isExtendedDataEnabled {
                        NavigationLink(destination: StudioDetailsView(malId: studio.id, initialStudio: nil)) {
                            Text(studio.name)
                                .bold()
                        }
                    } else {
                        Text(studios.map(\.name), format: .list(type: .and))
                            .bold()
                    }
                }
            }
        }
    }
}

private struct AuthorsView: View {
    let authors: [Author]

    var body: some View {
        if !authors.isEmpty {
            Spacer()
            Text("Created by")

            Text(authors.map {"\($0.node.fullName) (\($0.role))"}, format: .list(type: .and))
        }
    }
}
