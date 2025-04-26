import Foundation
import SwiftUI

extension Media {
    
    var getTitle: String {
        
        let value = UserDefaults.standard.string(forKey: "titleLanguage") ?? TitleLanguage.romanji.rawValue
        
        switch value {
        case "romanji":
            return title
        case "english":
            if let english = alternativeTitles?.en, !english.isEmpty {
                return english
            } else {
                return title
            }
        case "japanese":
            if let japanese = alternativeTitles?.ja, !japanese.isEmpty {
                return japanese
            } else {
                return title
            }
            
        default:
            return "Unknown title"
        }
    }
    
    var getReleaseYear: String {
        guard let startDate = startDate else {
            return String(localized: "Unknown release year")
        }
        return String(startDate.prefix(4))
    }

    
    var getStartDate: String {
        startDate ?? String(localized: "Unknown startDate")
    }
    
    var getEpisodes: Int {
        episodes ?? 0
    }
    
    var getAuthors: [AuthorInfos] {
        authors ?? []
    }
    
    var getListStatus: ListStatus {
        listStatus ?? ListStatus(status: "", rating: 0, watchedEpisodes: 0, readChapters: 0)
    }
    
    var getRecommendations: [MediaNode] {
        recommendations ?? []
    }
    
    var getRelatedAnimes: [MediaNode] {
        relatedAnimes ?? []
    }
    
    var getRelatedMangas: [MediaNode] {
        relatedMangas ?? []
    }
    
    var getMoreImages: [Images] {
        moreImages ?? []
    }
    
    var getStudios: [Studio] {
        studios ?? []
    }
    
    var getGenres: [Genre] {
        genres ?? []
    }
    
    var getCover: String {
        images.large
    }
    
    var getMediaStatus: StatusWrapper {

        switch isMangaOrAnime(from: type ?? "") {
        case .anime:
            let animeStatus = AnimeStatus(rawValue: status ?? "") ?? .unknown
            return .anime(animeStatus)
        case .manga:
            let mangaStatus = MangaStatus(rawValue: status ?? "") ?? .unknown
            return .manga(mangaStatus)
        case .unknown:
            return .unknown
        }
    }
    
    var getMediaType: MediaType {
        switch isMangaOrAnime(from: type ?? "") {
        case .anime: MediaType.anime
        case .manga: MediaType.manga
        case .unknown:
            MediaType.unknown
        }
    }
    
    var getType: TypeWrapper {
        let raw = type ?? ""

        switch isMangaOrAnime(from: raw) {
        case .anime:
            let anime = AnimeType(rawValue: raw) ?? .unknown
            return .anime(anime)
        case .manga:
            let manga = MangaType(rawValue: raw) ?? .unknown
            return .manga(manga)
        case .unknown:
            return .anime(.unknown)
        }
    }
    
    var getVolumes: Int {
        numberOfVolumes ?? 0
    }
    
    var getChapters: Int {
        numberOfChapters ?? 0
    }
    
    var getUsers: Int {
        users ?? 0
    }
    
    var getDescription: String {
        description ?? String(localized: "No description available")
    }
    
    var getScore: Double {
        score ?? 0
    }
    
    var getEndDate: String {
        endDate ?? "Unknown endDate"
    }
    
    var getRank: Int {
        rank ?? 0
    }
    
    var getPopularity: Int {
        popularity ?? 0
    }
    
    private func isMangaOrAnime(from type: String) -> MediaType {
        if MangaType(rawValue: type) != nil {
            return .manga
        }
        if AnimeType(rawValue: type) != nil {
            return .anime
        }
        return .unknown
    }
}
