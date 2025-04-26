import SwiftUI

struct GeneralInformationView: View {
    
    let type: TypeWrapper
    let episodes: Int?
    let numberOfChapters: Int?
    let numberOfVolumes: Int?
    let startDate: String
    let endDate: String
    let studios: [Studio]
    let authorInfos: [AuthorInfos]
    let status: StatusWrapper
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Text("General information")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                
                Text(formattedDetails(chapters: numberOfChapters ?? 0, volumes: numberOfVolumes ?? 0, episodes: episodes ?? 0))
                    .font(.body)
                
                Text(formattedRelease(startDate: startDate, endDate: endDate))
                    .font(.body)
                
                Spacer()
                if (!studios.isEmpty && authorInfos.isEmpty) {
                    HStack(spacing: 5) {
                        Text("Made by")
                            .bold()
                        ForEach(studios, id: \.id) {studio in
                            Text(studio.name)
                        }
                    }
                }
                
                if(!authorInfos.isEmpty && studios.isEmpty) {
                    
                    Text("By")
                        .bold()
                    VStack (alignment: .leading) {
                        ForEach(authorInfos, id: \.self) { authorElement in
                            Text(authorElement.getAuthor)
                        }
                    }
                }
                
                
            }.padding(.bottom, 10)
        }
    }
    
    func formattedDetails(chapters: Int, volumes: Int, episodes: Int) -> String {
        switch type {
        case .manga(let manga):
            return formattedMangaDetails(type: manga, chapters: chapters, volumes: volumes)
        case .anime(let anime):
            return formattedAnimeDetails(type: anime, episodes: episodes)
        }
    }
    
    private func formattedAnimeDetails(type: AnimeType, episodes: Int) -> String {
        switch (type, episodes) {
        case (.movie, 1):
            return type.displayName
        case (.movie, let episodes) where episodes > 1:
            return String(localized: "\(type.displayName), \(episodes) parts")
        case (.tv, 0):
            return type.displayName
        case (.tv, let episodes):
            return String(localized: "\(type.displayName), \(episodes) episodes")
        default:
            return type.displayName
        }
    }
    
    private func formattedMangaDetails(type: MangaType, chapters: Int, volumes: Int) -> String {
        
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
    
    private func formatReleaseRange(startFormatted: String?, endFormatted: String?, status: AnimeStatus) -> String {
        
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
    
    private func formatPublishRange(startFormatted: String?, endFormatted: String?, status: MangaStatus) -> String {
        
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

#Preview {
    let exampleStudios: [Studio] = [
        Studio(id: 1, name: "Netflix"),
        Studio(id: 2, name: "Amazon")
    ]
    
    GeneralInformationView(
        type: .anime(.tv),
        episodes: 10,
        numberOfChapters: nil,
        numberOfVolumes: nil,
        startDate: "2024-10-10",
        endDate: "2025-10-10",
        studios: exampleStudios,
        authorInfos: [],
        status: .anime(.currentlyAiring)
    )
}
