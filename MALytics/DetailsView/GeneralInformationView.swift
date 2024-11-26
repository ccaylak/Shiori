import SwiftUI

struct GeneralInformationView: View {
    
    let type: String
    let episodes: Int?
    let numberOfChapters: Int?
    let numberOfVolumes: Int?
    let startDate: String
    let endDate: String
    let studios: [Studio]
    let authorInfos: [AuthorInfos]
    let status: String
    
    var mediaType: Any? {
        if let mangaType = MangaType(rawValue: type) {
            return mangaType
        } else if let animeType = AnimeType(rawValue: type) {
            return animeType
        }
        return nil
    }
    
    var statusType: Any? {
        if let mangaStatus = MangaStatus(rawValue: status) {
            return mangaStatus
        } else if let animeStatus = AnimeStatus(rawValue: status) {
            return animeStatus
        }
        return nil
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Text("General information")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                
                Text(formattedDetails(chapters: numberOfChapters ?? 0, volumes: numberOfVolumes ?? 0, episodes: episodes ?? 0))
                    .font(.body)
                
                Text(formattedRelease(startDate: startDate, endDate: endDate))
                    .font(.body)
                
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
                    Spacer()
                    VStack (alignment: .leading) {
                        ForEach(authorInfos, id: \.self) { authorElement in
                            HStack() {
                                Text(authorElement.author?.firstName ?? "")
                                Text(authorElement.author?.lastName ?? "")
                                Text(authorElement.role)
                            }
                        }
                    }
                }
                
                
            }.padding(.bottom, 10)
        }
    }
    
    func formattedDetails(chapters: Int, volumes: Int, episodes: Int) -> String {
        var formattedResult = ""
        if mediaType is MangaType{
            formattedResult = formattedMangaDetails(type: mediaType as! MangaType, chapters: chapters, volumes: volumes)
        } else if mediaType is AnimeType {
            formattedResult = formattedAnimeDetails(type: mediaType as! AnimeType, episodes: episodes)
        }
        return formattedResult
    }
    
    private func formattedAnimeDetails(type: AnimeType, episodes: Int) -> String {
        switch (type, episodes) {
        case (.movie, 1):
            return type.displayName
        case (.movie, let episodes) where episodes > 1:
            return "\(type.displayName), \(episodes) parts"
        case (.tv, 0):
            return type.displayName
        case (.tv, let episodes):
            return "\(type.displayName), \(episodes) episodes"
        default:
            return type.displayName
        }
    }
    
    private func formattedMangaDetails(type: MangaType, chapters: Int, volumes: Int) -> String {
        
        switch (chapters, volumes) {
        case (let chapters, let volumes) where chapters > 0 && volumes > 0:
            return "\(type.displayName), \(chapters) chapters in \(volumes) volumes"
        case (let chapters, 0) where chapters > 0:
            return "\(type.displayName), \(chapters) chapters"
        default:
            return type.displayName
        }
        
    }
    
    func formattedRelease(startDate: String, endDate: String) -> String {
        var formattedReleaseDate = ""
        let (startFormatted, endFormatted) = String.formatDates(startDate: startDate, endDate: endDate)
        
        if statusType is MangaStatus {
            formattedReleaseDate = formatPublishRange(startFormatted: startFormatted, endFormatted: endFormatted, status: statusType as! MangaStatus)
        } else if statusType is AnimeStatus {
            formattedReleaseDate = formatReleaseRange(startFormatted: startFormatted, endFormatted: endFormatted, status: statusType as! AnimeStatus)
        }
        
        return formattedReleaseDate
    }
    
    private func formatReleaseRange(startFormatted: String?, endFormatted: String?, status: AnimeStatus) -> String {
        
        switch status {
        case .finishedAiring where startFormatted != nil && endFormatted != nil && startFormatted == endFormatted:
            return "Aired in \(startFormatted!)"
        case .finishedAiring where startFormatted != nil && endFormatted != nil:
            return "Aired from \(startFormatted!) - \(endFormatted!)"
        case .currentlyAiring where startFormatted != nil:
            return "Airing since \(startFormatted!)"
        case .notYetAired where startFormatted != nil:
            return "Will air in \(startFormatted!)"
        case .notYetAired where startFormatted == nil && endFormatted == nil:
            return "Unkown release date"
        default:
            return "Unkown release date"
        }
    }
    
    private func formatPublishRange(startFormatted: String?, endFormatted: String?, status: MangaStatus) -> String {
        
        switch status {
        case .finished where startFormatted != nil && endFormatted != nil && startFormatted == endFormatted:
            return "Published in \(startFormatted!)"
        case .finished where startFormatted != nil && endFormatted != nil:
            return "Published from \(startFormatted!) - \(endFormatted!)"
        case .currentlyPublishing where startFormatted != nil:
            return "Publishing since \(startFormatted!)"
        case .notYetPublished where startFormatted != nil:
            return "Will publish in \(startFormatted!)"
        case .notYetPublished where startFormatted == nil && endFormatted == nil:
            return "Unkown publishing date"
        case .discontinued:
            return "Published from \(startFormatted!) - \(endFormatted ?? "Unknown")"
        case .onHiatus:
            return "Published from \(startFormatted!) - \(endFormatted ?? "Unknown")"
        default:
            return "Unkown publishing date"
        }
    }
}

#Preview {
    let exampleStudios: [Studio] = [
        Studio(id: 1, name: "Netflix"),
        Studio(id: 2, name: "Amazon")
    ]
    
    GeneralInformationView(
        type: "tv",
        episodes: 10,
        numberOfChapters: nil,
        numberOfVolumes: nil,
        startDate: "2024-10-10",
        endDate: "2025-10-10",
        studios: exampleStudios,
        authorInfos: [],
        status: "currently_airing"
    )
}
