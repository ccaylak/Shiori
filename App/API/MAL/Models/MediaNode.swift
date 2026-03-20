import Foundation

struct MediaNode: Decodable, Hashable {
    
    private(set) var id: Int
    private(set) var title: String
    private(set) var mainPicture: Picture
    private(set) var alternativeTitles: AlternativeTitles?
    private(set) var startDate: String?
    private(set) var endDate: String?
    private(set) var synopsis: String?
    private(set) var mean: Double?
    private(set) var rank: Int?
    private(set) var popularity: Int?
    private(set) var numListUsers: Int?
    private(set) var numScoringUsers: Int?
    private(set) var nsfw: String?
    private(set) var genres: [MediaGenre]?
    private(set) var mediaType: String?
    private(set) var status: String?
    private(set) var myListStatus: MyListStatus?
    private(set) var numEpisodes: Int?
    private(set) var numVolumes: Int?
    private(set) var numChapters: Int?
    private(set) var startSeason: StartSeason?
    private(set) var averageEpisodeDuration: Int?
    private(set) var rating: String?
    private(set) var studios: [Studio]?
    private(set) var authors: [Author]?
    private(set) var pictures: [Picture]?
    private(set) var relatedAnime: [Media]?
    private(set) var relatedManga: [Media]?
    private(set) var recommendations: [Media]?
    
    init(
        id: Int,
        title: String,
        mainPicture: Picture,
        mediaType: String? = nil
    ) {
        self.id = id
        self.title = title
        self.mainPicture = mainPicture
        self.mediaType = mediaType
        
        // Alles andere mit Default-Werten initialisieren
        self.alternativeTitles = nil
        self.startDate = nil
        self.endDate = nil
        self.synopsis = nil
        self.mean = nil
        self.rank = 0
        self.popularity = nil
        self.numListUsers = 0
        self.numScoringUsers = 0
        self.nsfw = nil
        self.genres = []
        self.status = nil
        self.myListStatus = nil
        self.numEpisodes = 0
        self.numVolumes = 0
        self.numChapters = 0
        self.startSeason = nil
        self.averageEpisodeDuration = nil
        self.rating = nil
        self.studios = []
        self.authors = []
        self.pictures = []
        self.relatedAnime = []
        self.relatedManga = []
        self.recommendations = []
    }
}

extension MediaNode {
    
    var preferredTitle: String {
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
    
    var getMyListStatus: MyListStatus {
        myListStatus ?? MyListStatus()
    }
    
    var releaseStartDate: String {
        startDate ?? ""
    }
    
    var releaseEndDate: String {
        endDate ?? ""
    }
    
    var getStartSeason: StartSeason {
        startSeason ?? StartSeason()
    }
    
    var genresList: [MediaGenre] {
        genres ?? []
    }
    
    var recommendationsList: [Media] {
        recommendations ?? []
    }
    
    var authorsList: [Author] {
        authors ?? []
    }
    
    var studiosList: [Studio] {
        studios ?? []
    }
    
    var listUserCount: Int {
        numListUsers ?? 0
    }
    
    var getEntryStatus: ProgressStatus {
        switch isMangaOrAnime {
            
        case .anime:
            if let raw = myListStatus?.status,
               let animeStatus = ProgressStatus.Anime(rawValue: raw) {
                return .anime(animeStatus)
            } else {
                return .unknown
            }
            
        case .manga:
            if let raw = myListStatus?.status,
               let mangaStatus = ProgressStatus.Manga(rawValue: raw) {
                return .manga(mangaStatus)
            } else {
                return .unknown
            }
        }
    }
    
    var animeStatus: ProgressStatus.Anime {
        if case let .anime(status) = getEntryStatus {
            return status
        } else {
            return .planToWatch // default
        }
    }
    
    var mangaStatus: ProgressStatus.Manga {
        if case let .manga(status) = getEntryStatus {
            return status
        } else {
            return .planToRead // default
        }
    }
    
    var isMangaOrAnime: SeriesType {
        let seriesType = mediaType?.lowercased() ?? ""
        
        if MediaType.Manga(rawValue: seriesType) != nil {
            return .manga
        }
        if MediaType.Anime(rawValue: seriesType) != nil {
            return .anime
        }
        
        preconditionFailure("Unexpected mediaType: \(seriesType)")
    }
    
    var resultCount: Int {
        if isMangaOrAnime == .manga {
            return numChapters ?? 0
        }
        return numEpisodes ?? 0
    }
    
    var specificMediaType: MediaType {
        let value = mediaType?.lowercased() ?? ""

        if let manga = MediaType.Manga(rawValue: value) {
            return .manga(manga)
        }

        if let anime = MediaType.Anime(rawValue: value) {
            return .anime(anime)
        }

        return .anime(.unknown)
    }

    var specificStatus: Status {
        let value = status?.lowercased() ?? ""

        if let manga = Status.Manga(rawValue: value) {
            return .manga(manga)
        }

        if let anime = Status.Anime(rawValue: value) {
            return .anime(anime)
        }

        return .anime(.unknown)
    }
    
    var synopsisText: String {
        synopsis ?? "No synopsis available"
    }
    
    var meanValue: Double {
        mean ?? 0.0
    }
    
    var rankValue: Int {
        rank ?? 0
    }
    
    var chapters: Int {
        numChapters ?? 0
    }
    
    var episodes: Int {
        numEpisodes ?? 0
    }
    
    var volumes: Int {
        numVolumes ?? 0
    }
    
    var yearLabel: String {
        guard let startDate else {
            return "Unknown release year"
        }
        return String(startDate.prefix(4))
    }
    
    var averageEpisodeDurationInMinutes: Int {
        guard let duration = averageEpisodeDuration else { return 0 }
        return duration / 60
    }
}
