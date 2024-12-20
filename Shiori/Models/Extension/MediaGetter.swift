import Foundation

extension Media {
    var getReleaseYear: String {
        String(startDate?.prefix(4) ?? "Unknown startDate")
    }
    
    var getStartDate: String {
        startDate ?? "Unknown startDate"
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
    
    var getStatus: String {
        // hier könnte man mit enums arbeiten
        status ?? "Unknown status"
    }
    
    var getType: String {
        // hier könnte man mit enums arbeiten
        type ?? "Unknown type"
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
        description ?? "Unknown description"
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
}
