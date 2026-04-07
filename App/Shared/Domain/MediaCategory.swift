import Foundation

enum MediaCategory: Hashable {
    case demographic(Demographic)
    case explicit(ExplicitGenre)
    case genre(Genre)
    case theme(Theme)
    case unknown(String)
    
    var displayName: String {
        switch self {
        case .demographic(let demographic): return demographic.displayName
        case .explicit(let genre): return genre.displayName
        case .genre(let genre): return genre.displayName
        case .theme(let theme): return theme.displayName
        case .unknown(let value): return value
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .demographic: return String(localized: "Demographics")
        case .explicit: return String(localized: "Explicit Genres")
        case .genre: return String(localized: "Genres")
        case .theme: return String(localized: "Themes")
        case .unknown: return String(localized: "Other")
        }
    }
    
    var icon: String {
        switch self {
        case .demographic: return "person.2.fill"
        case .explicit: return "eye.slash.fill"
        case .genre: return "tag.fill"
        case .theme: return "theatermasks.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
    
    init(name: String) {
        if let value = Genre(rawValue: name) {
            self = .genre(value)
        } else if let value = ExplicitGenre(rawValue: name) {
            self = .explicit(value)
        } else if let value = Theme(rawValue: name) {
            self = .theme(value)
        } else if let value = Demographic(rawValue: name) {
            self = .demographic(value)
        } else {
            self = .unknown(name)
        }
    }
    
    enum Genre: String, CaseIterable, Hashable {
        case action = "Action"
        case adventure = "Adventure"
        case avantGarde = "Avant Garde"
        case awardWinning = "Award Winning"
        case boysLove = "Boys Love"
        case comedy = "Comedy"
        case drama = "Drama"
        case fantasy = "Fantasy"
        case girlsLove = "Girls Love"
        case gourmet = "Gourmet"
        case horror = "Horror"
        case mystery = "Mystery"
        case romance = "Romance"
        case sciFi = "Sci-Fi"
        case sliceOfLife = "Slice of Life"
        case sports = "Sports"
        case supernatural = "Supernatural"
        case suspense = "Suspense"
        
        var displayName: String {
            switch self {
            case .action: return String(localized: "Action", comment: "Genre")
            case .adventure: return String(localized: "Adventure", comment: "Genre")
            case .avantGarde: return String(localized: "Avant Garde", comment: "Genre")
            case .awardWinning: return String(localized: "Award Winning", comment: "Genre")
            case .boysLove: return String(localized: "Boys Love", comment: "Genre")
            case .comedy: return String(localized: "Comedy", comment: "Genre")
            case .drama: return String(localized: "Drama", comment: "Genre")
            case .fantasy: return String(localized: "Fantasy", comment: "Genre")
            case .girlsLove: return String(localized: "Girls Love", comment: "Genre")
            case .gourmet: return String(localized: "Gourmet", comment: "Genre")
            case .horror: return String(localized: "Horror", comment: "Genre")
            case .mystery: return String(localized: "Mystery", comment: "Genre")
            case .romance: return String(localized: "Romance", comment: "Genre")
            case .sciFi: return String(localized: "Sci-Fi", comment: "Genre")
            case .sliceOfLife: return String(localized: "Slice of Life", comment: "Genre")
            case .sports: return String(localized: "Sports", comment: "Genre")
            case .supernatural: return String(localized: "Supernatural", comment: "Genre")
            case .suspense: return String(localized: "Suspense", comment: "Genre")
            }
        }
    }
    
    enum ExplicitGenre: String, CaseIterable, Hashable {
        case ecchi = "Ecchi"
        case erotica = "Erotica"
        case hentai = "Hentai"
        
        var displayName: String {
            switch self {
            case .ecchi: return String(localized: "Ecchi", comment: "Explicit Genre")
            case .erotica: return String(localized: "Erotica", comment: "Explicit Genre")
            case .hentai: return String(localized: "Hentai", comment: "Explicit Genre")
            }
        }
    }
    
    enum Theme: String, CaseIterable, Hashable {
        case adultCast = "Adult Cast"
        case anthropomorphic = "Anthropomorphic"
        case cgdct = "CGDCT"
        case childcare = "Childcare"
        case combatSports = "Combat Sports"
        case crossdressing = "Crossdressing"
        case delinquents = "Delinquents"
        case detective = "Detective"
        case educational = "Educational"
        case gagHumor = "Gag Humor"
        case gore = "Gore"
        case harem = "Harem"
        case highStakesGame = "High Stakes Game"
        case historical = "Historical"
        case idolsFemale = "Idols (Female)"
        case idolsMale = "Idols (Male)"
        case isekai = "Isekai"
        case iyashikei = "Iyashikei"
        case lovePolygon = "Love Polygon"
        case loveStatusQuo = "Love Status Quo"
        case magicalSexShift = "Magical Sex Shift"
        case mahouShoujo = "Mahou Shoujo"
        case martialArts = "Martial Arts"
        case mecha = "Mecha"
        case medical = "Medical"
        case memoir = "Memoir"
        case military = "Military"
        case music = "Music"
        case mythology = "Mythology"
        case organizedCrime = "Organized Crime"
        case otakuCulture = "Otaku Culture"
        case parody = "Parody"
        case performingArts = "Performing Arts"
        case pets = "Pets"
        case psychological = "Psychological"
        case racing = "Racing"
        case reincarnation = "Reincarnation"
        case reverseHarem = "Reverse Harem"
        case samurai = "Samurai"
        case school = "School"
        case showbiz = "Showbiz"
        case space = "Space"
        case strategyGame = "Strategy Game"
        case superPower = "Super Power"
        case survival = "Survival"
        case teamSports = "Team Sports"
        case timeTravel = "Time Travel"
        case urbanFantasy = "Urban Fantasy"
        case vampire = "Vampire"
        case videoGame = "Video Game"
        case villainess = "Villainess"
        case visualArts = "Visual Arts"
        case workplace = "Workplace"
        
        var displayName: String {
            switch self {
            case .adultCast: return String(localized: "Adult Cast", comment: "Theme")
            case .anthropomorphic: return String(localized: "Anthropomorphic", comment: "Theme")
            case .cgdct: return String(localized: "CGDCT", comment: "Theme")
            case .childcare: return String(localized: "Childcare", comment: "Theme")
            case .combatSports: return String(localized: "Combat Sports", comment: "Theme")
            case .crossdressing: return String(localized: "Crossdressing", comment: "Theme")
            case .delinquents: return String(localized: "Delinquents", comment: "Theme")
            case .detective: return String(localized: "Detective", comment: "Theme")
            case .educational: return String(localized: "Educational", comment: "Theme")
            case .gagHumor: return String(localized: "Gag Humor", comment: "Theme")
            case .gore: return String(localized: "Gore", comment: "Theme")
            case .harem: return String(localized: "Harem", comment: "Theme")
            case .highStakesGame: return String(localized: "High Stakes Game", comment: "Theme")
            case .historical: return String(localized: "Historical", comment: "Theme")
            case .idolsFemale: return String(localized: "Idols (Female)", comment: "Theme")
            case .idolsMale: return String(localized: "Idols (Male)", comment: "Theme")
            case .isekai: return String(localized: "Isekai", comment: "Theme")
            case .iyashikei: return String(localized: "Iyashikei", comment: "Theme")
            case .lovePolygon: return String(localized: "Love Polygon", comment: "Theme")
            case .loveStatusQuo: return String(localized: "Love Status Quo", comment: "Theme")
            case .magicalSexShift: return String(localized: "Magical Sex Shift", comment: "Theme")
            case .mahouShoujo: return String(localized: "Mahou Shoujo", comment: "Theme")
            case .martialArts: return String(localized: "Martial Arts", comment: "Theme")
            case .mecha: return String(localized: "Mecha", comment: "Theme")
            case .medical: return String(localized: "Medical", comment: "Theme")
            case .memoir: return String(localized: "Memoir", comment: "Theme")
            case .military: return String(localized: "Military", comment: "Theme")
            case .music: return String(localized: "Music", comment: "Theme")
            case .mythology: return String(localized: "Mythology", comment: "Theme")
            case .organizedCrime: return String(localized: "Organized Crime", comment: "Theme")
            case .otakuCulture: return String(localized: "Otaku Culture", comment: "Theme")
            case .parody: return String(localized: "Parody", comment: "Theme")
            case .performingArts: return String(localized: "Performing Arts", comment: "Theme")
            case .pets: return String(localized: "Pets", comment: "Theme")
            case .psychological: return String(localized: "Psychological", comment: "Theme")
            case .racing: return String(localized: "Racing", comment: "Theme")
            case .reincarnation: return String(localized: "Reincarnation", comment: "Theme")
            case .reverseHarem: return String(localized: "Reverse Harem", comment: "Theme")
            case .samurai: return String(localized: "Samurai", comment: "Theme")
            case .school: return String(localized: "School", comment: "Theme")
            case .showbiz: return String(localized: "Showbiz", comment: "Theme")
            case .space: return String(localized: "Space", comment: "Theme")
            case .strategyGame: return String(localized: "Strategy Game", comment: "Theme")
            case .superPower: return String(localized: "Super Power", comment: "Theme")
            case .survival: return String(localized: "Survival", comment: "Theme")
            case .teamSports: return String(localized: "Team Sports", comment: "Theme")
            case .timeTravel: return String(localized: "Time Travel", comment: "Theme")
            case .urbanFantasy: return String(localized: "Urban Fantasy", comment: "Theme")
            case .vampire: return String(localized: "Vampire", comment: "Theme")
            case .videoGame: return String(localized: "Video Game", comment: "Theme")
            case .villainess: return String(localized: "Villainess", comment: "Theme")
            case .visualArts: return String(localized: "Visual Arts", comment: "Theme")
            case .workplace: return String(localized: "Workplace", comment: "Theme")
            }
        }
    }
    
    enum Demographic: String, CaseIterable, Hashable {
        case shounen = "Shounen"
        case seinen = "Seinen"
        case shoujo = "Shoujo"
        case josei = "Josei"
        case kids = "Kids"
        
        var displayName: String {
            switch self {
            case .shounen: return String(localized: "Shounen", comment: "Demographic")
            case .seinen: return String(localized: "Seinen", comment: "Demographic")
            case .shoujo: return String(localized: "Shoujo", comment: "Demographic")
            case .josei: return String(localized: "Josei", comment: "Demographic")
            case .kids: return String(localized: "Kids", comment: "Demographic")
            }
        }
    }
}
