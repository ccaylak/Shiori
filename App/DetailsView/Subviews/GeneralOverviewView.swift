import SwiftUI

struct GeneralOverviewView: View {
    
    let type: FormatType
    let episodes: Int
    let numberOfChapters: Int
    let numberOfVolumes: Int
    let startDate: String
    let minutes: Int
    let endDate: String
    let studios: [Studio]
    let authorInfos: [AuthorInfos]
    let status: Status
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("General information")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                
                Text(formattedDetails(chapters: numberOfChapters, volumes: numberOfVolumes, episodes: episodes, minutes: minutes))
                    .font(.body)
                
                Text(formattedRelease(startDate: startDate, endDate: endDate))
                    .font(.body)
                
                StudiosView(studios: studios)
                AuthorsView(authorInfos: authorInfos)
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
    
    private func formattedAnimeDetails(type: FormatType.Anime, episodes: Int, minutes: Int) -> String {
        switch (type, episodes) {
        case (.movie, 1):
            return type.displayName
        case (.movie, let episodes) where episodes > 1:
            return String(localized: "\(type.displayName), \(episodes) parts • \(minutes) minutes (≈\(formattedDuration(from: episodes*minutes)))")
        case (.tv, 0):
            return type.displayName
        case (.tv, let episodes):
            return String(localized: "\(type.displayName), \(episodes) episodes • \(minutes) minutes (≈\(formattedDuration(from: episodes*minutes)))")
        default:
            return type.displayName
        }
    }
    
    private func formattedDuration(from totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formattedMangaDetails(type: FormatType.Manga, chapters: Int, volumes: Int) -> String {
        
        switch (chapters, volumes) {
        case (let chapters, let volumes) where chapters > 0 && volumes > 0:
            return String(localized: "\(type.displayName), \(chapters) chapters in \(volumes) volumes")
        case (let chapters, 0) where chapters > 0:
            return String(localized: "\(type.displayName), \(chapters) chapters")
        default:
            return type.displayName
        }
        
    }
    
    func formattedRelease(startDate: String, endDate: String) -> String {
        var formattedReleaseDate = ""
        let (startFormatted, endFormatted) = String.formatDates(startDate: startDate, endDate: endDate)
        
        switch status {
        case .anime(let animeStatus): formattedReleaseDate = formatReleaseRange(startFormatted: startFormatted, endFormatted: endFormatted, status: animeStatus)
        case .manga(let mangaStatus):
            formattedReleaseDate = formatPublishRange(startFormatted: startFormatted, endFormatted: endFormatted, status: mangaStatus)
        case .unknown:
            formattedReleaseDate = ""
        }
        
        
        return formattedReleaseDate
    }
    
    private func formatReleaseRange(startFormatted: String?, endFormatted: String?, status: Status.Anime) -> String {
        
        switch status {
        case .finishedAiring where startFormatted != nil && endFormatted != nil && startFormatted == endFormatted:
            return String(localized: "Aired in \(startFormatted!)")
        case .finishedAiring where startFormatted != nil && endFormatted != nil:
            return String(localized: "Aired from \(startFormatted!) - \(endFormatted!)")
        case .currentlyAiring where startFormatted != nil:
            return String(localized: "Airing since \(startFormatted!)")
        case .notYetAired where startFormatted != nil:
            return String(localized: "Will air in \(startFormatted!)")
        case .notYetAired where startFormatted == nil && endFormatted == nil:
            return String(localized: "Unknown airing date")
        default:
            return String(localized: "Unknown airing date")
        }
    }
    
    private func formatPublishRange(startFormatted: String?, endFormatted: String?, status: Status.Manga) -> String {
        
        switch status {
        case .finished where startFormatted != nil && endFormatted != nil && startFormatted == endFormatted:
            return String(localized: "Published in \(startFormatted!)")
        case .finished where startFormatted != nil && endFormatted != nil:
            return String(localized: "Published from \(startFormatted!) - \(endFormatted!)")
        case .currentlyPublishing where startFormatted != nil:
            return String(localized: "Publishing since \(startFormatted!)")
        case .notYetPublished where startFormatted != nil:
            return String(localized: "Will publish in \(startFormatted!)")
        case .notYetPublished where startFormatted == nil && endFormatted == nil:
            return String(localized: "Unknown publishing date")
        case .discontinued, .onHiatus:
            return String(localized: "Published from \(startFormatted!) - \(endFormatted ?? "Unknown")")
        default:
            return String(localized: "Unknown publishing date")
        }
    }
}

private struct StudiosView: View {
    let studios: [Studio]
    
    var body: some View {
        if (!studios.isEmpty) {
            Spacer()
            HStack(spacing: 5) {
                Text("Made by")
                    
                ForEach(studios, id: \.id) {studio in
                    Text(studio.name)
                        .bold()
                }
            }
        }
    }
}

private struct AuthorsView: View {
    let authorInfos: [AuthorInfos]
    
    var body: some View {
        if(!authorInfos.isEmpty) {
            Spacer()
            Text("By")
            
            VStack (alignment: .leading) {
                ForEach(authorInfos, id: \.self) { authorElement in
                    Text(authorElement.getAuthor)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    let exampleStudios: [Studio] = [
        Studio(id: 1, name: "Netflix"),
        Studio(id: 2, name: "Amazon")
    ]
    
    GeneralOverviewView(
        type: .anime(.tv),
        episodes: 10,
        numberOfChapters: 10,
        numberOfVolumes: 0,
        startDate: "2024-10-10",
        minutes: 21,
        endDate: "2025-10-10",
        studios: exampleStudios,
        authorInfos: [],
        status: .anime(.currentlyAiring)
    )
}
