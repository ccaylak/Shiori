import SwiftUI

struct GeneralInformationView: View {
    
    let typeString: String
    let episodes: Int?
    let numberOfChapters: Int?
    let numberOfVolumes: Int?
    let startDate: String
    let endDate: String
    let studios: [Studio]
    let authorInfos: [AuthorInfos]
    let statusString: String
    
    private var animeType: AnimeType {
        AnimeType(rawValue: typeString) ?? .unknown
    }
    
    private var animeStatus: AnimeStatus {
        AnimeStatus(rawValue: statusString) ?? .unknown
    }
    
    private var mangaType: MangaType {
        MangaType(rawValue: typeString) ?? .unknown
    }
    
    private var mangaStatus: MangaStatus {
        MangaStatus(rawValue: statusString) ?? .unknown
    }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("General information")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                
                if(episodes != nil) {
                    Text(formatTypeAndEpisodes(type: animeType, episodes: episodes!))
                        .font(.body)
                }
                if(numberOfChapters != nil || numberOfVolumes != nil) {
                    Text(formatTypeAndChaptersVolumes(type: mangaType, chapters: numberOfChapters!, volumes: numberOfVolumes ?? 0))
                        .font(.body)
                }
                
                if (episodes != nil) {
                    Text(formatReleaseRange(startDate: startDate, endDate: endDate, status: animeStatus) ?? "")
                        .font(.body)
                }
                if (numberOfChapters != nil || numberOfVolumes != nil) {
                    Text(formatPublishRange(startDate: startDate, endDate: endDate, status: mangaStatus) ?? "")
                        .font(.body)
                }
                
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
    
    func formatTypeAndEpisodes(type: AnimeType, episodes: Int) -> String {
        
        if (episodes == 1 && type == .movie) {
            return type.displayName
        }
        if (episodes > 1 && type == .movie) {
            return "\(type.displayName), \(episodes) parts"
        }
        
        if (episodes == 0 && type == .tv) {
            return type.displayName
        }
        
        return "\(type.displayName), \(episodes) episodes"
    }
    
    func formatTypeAndChaptersVolumes(type: MangaType, chapters: Int, volumes: Int) -> String {
        
        if (chapters != 0 && volumes != 0) {
            return "\(type.displayName), \(chapters) chapters in \(volumes) volumes"
        }
        if (chapters != 0 && volumes == 0) {
            return "\(type.displayName), \(chapters) chapters"
        }
        
        return "\(type.displayName)"
    }
    
    func formatReleaseRange(startDate: String, endDate: String, status: AnimeStatus) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        
        let startFormatted = startDate.isEmpty ? nil : dateFormatter.date(from: startDate).flatMap { outputFormatter.string(from: $0) }
        let endFormatted = endDate.isEmpty ? nil : dateFormatter.date(from: endDate).flatMap { outputFormatter.string(from: $0) }
        
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
            return nil
        }
    }
    
    func formatPublishRange(startDate: String, endDate: String, status: MangaStatus) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        
        let startFormatted = startDate.isEmpty ? nil : dateFormatter.date(from: startDate).flatMap { outputFormatter.string(from: $0) }
        let endFormatted = endDate.isEmpty ? nil : dateFormatter.date(from: endDate).flatMap { outputFormatter.string(from: $0) }
        
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
            return nil
        }
    }
}

#Preview {
    let exampleStudios: [Studio] = [
        Studio(id: 1, name: "Netflix"),
        Studio(id: 2, name: "Amazon")
    ]
    
    GeneralInformationView(
        typeString: "tv",
        episodes: 10,
        numberOfChapters: nil,
        numberOfVolumes: nil,
        startDate: "2024-10-10",
        endDate: "2025-10-10",
        studios: exampleStudios,
        authorInfos: [],
        statusString: "currently_airing"
    )
}
