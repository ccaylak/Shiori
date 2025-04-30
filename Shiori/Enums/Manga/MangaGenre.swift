import Foundation

enum MangaGenre: String, Equatable {
    case action = "Action"
    case adventure = "Adventure"
    case racing = "Racing"
    case comedy = "Comedy"
    case avantGarde = "Avant Garde"
    case mythology = "Mythology"
    case mystery = "Mystery"
    case drama = "Drama"
    case ecchi = "Ecchi"
    case fantasy = "Fantasy"
    case strategyGame = "Strategy Game"
    case hentai = "Hentai"
    case historical = "Historical"
    case horror = "Horror"
    case kids = "Kids"
    case martialArts = "Martial Arts"
    case mecha = "Mecha"
    case music = "Music"
    case parody = "Parody"
    case samurai = "Samurai"
    case romance = "Romance"
    case school = "School"
    case sciFi = "Sci-Fi"
    case shoujo = "Shoujo"
    case girlsLove = "Girls Love"
    case shounen = "Shounen"
    case boysLove = "Boys Love"
    case space = "Space"
    case sports = "Sports"
    case superPower = "Super Power"
    case vampire = "Vampire"
    case harem = "Harem"
    case sliceOfLife = "Slice of Life"
    case supernatural = "Supernatural"
    case military = "Military"
    case detective = "Detective"
    case psychological = "Psychological"
    case seinen = "Seinen"
    case josei = "Josei"
    case crossdressing = "Crossdressing"
    case suspense = "Suspense"
    case awardWinning = "Award Winning"
    case gourmet = "Gourmet"
    case workplace = "Workplace"
    case erotica = "Erotica"
    case adultCast = "Adult Cast"
    case anthropomorphic = "Anthropomorphic"
    case cgdct = "CGDCT"
    case childcare = "Childcare"
    case combatSports = "Combat Sports"
    case delinquents = "Delinquents"
    case educational = "Educational"
    case gagHumor = "Gag Humor"
    case gore = "Gore"
    case highStakesGame = "High Stakes Game"
    case idolsFemale = "Idols (Female)"
    case idolsMale = "Idols (Male)"
    case isekai = "Isekai"
    case iyashikei = "Iyashikei"
    case lovePolygon = "Love Polygon"
    case magicalSexShift = "Magical Sex Shift"
    case mahouShoujo = "Mahou Shoujo"
    case medical = "Medical"
    case memoir = "Memoir"
    case organizedCrime = "Organized Crime"
    case otakuCulture = "Otaku Culture"
    case performingArts = "Performing Arts"
    case pets = "Pets"
    case reincarnation = "Reincarnation"
    case reverseHarem = "Reverse Harem"
    case loveStatusQuo = "Love Status Quo"
    case showbiz = "Showbiz"
    case survival = "Survival"
    case teamSports = "Team Sports"
    case timeTravel = "Time Travel"
    case videoGame = "Video Game"
    case villainess = "Villainess"
    case visualArts = "Visual Arts"
    case urbanFantasy = "Urban Fantasy"
    case unknown = "Unknown genre"
    
    var displayName: String {
        switch self {
        case .action: return String(localized: "Action", comment: "Manga genre")
        case .adventure: return String(localized: "Adventure", comment: "Manga genre")
        case .avantGarde: return String(localized: "Avant Garde", comment: "Manga genre")
        case .awardWinning: return String(localized: "Award Winning", comment: "Manga genre")
        case .boysLove: return String(localized: "Boys Love", comment: "Manga genre")
        case .comedy: return String(localized: "Comedy", comment: "Manga genre")
        case .drama: return String(localized: "Drama", comment: "Manga genre")
        case .fantasy: return String(localized: "Fantasy", comment: "Manga genre")
        case .girlsLove: return String(localized: "Girls Love", comment: "Manga genre")
        case .gourmet: return String(localized: "Gourmet", comment: "Manga genre")
        case .horror: return String(localized: "Horror", comment: "Manga genre")
        case .mystery: return String(localized: "Mystery", comment: "Manga genre")
        case .romance: return String(localized: "Romance", comment: "Manga genre")
        case .sciFi: return String(localized: "Sci-Fi", comment: "Manga genre")
        case .sliceOfLife: return String(localized: "Slice of Life", comment: "Manga genre")
        case .sports: return String(localized: "Sports", comment: "Manga genre")
        case .supernatural: return String(localized: "Supernatural", comment: "Manga genre")
        case .suspense: return String(localized: "Suspense", comment: "Manga genre")
        case .ecchi: return String(localized: "Ecchi", comment: "Manga genre")
        case .erotica: return String(localized: "Erotica", comment: "Manga genre")
        case .hentai: return String(localized: "Hentai", comment: "Manga genre")
        case .josei: return String(localized: "Josei", comment: "Manga genre")
        case .kids: return String(localized: "Kids", comment: "Manga genre")
        case .seinen: return String(localized: "Seinen", comment: "Manga genre")
        case .shoujo: return String(localized: "Shoujo", comment: "Manga genre")
        case .shounen: return String(localized: "Shounen", comment: "Manga genre")
        case .adultCast: return String(localized: "Adult Cast", comment: "Manga genre")
        case .anthropomorphic: return String(localized: "Anthropomorphic", comment: "Manga genre")
        case .cgdct: return String(localized: "CGDCT", comment: "Manga genre")
        case .childcare: return String(localized: "Childcare", comment: "Manga genre")
        case .combatSports: return String(localized: "Combat Sports", comment: "Manga genre")
        case .crossdressing: return String(localized: "Crossdressing", comment: "Manga genre")
        case .delinquents: return String(localized: "Delinquents", comment: "Manga genre")
        case .detective: return String(localized: "Detective", comment: "Manga genre")
        case .educational: return String(localized: "Educational", comment: "Manga genre")
        case .gagHumor: return String(localized: "Gag Humor", comment: "Manga genre")
        case .gore: return String(localized: "Gore", comment: "Manga genre")
        case .harem: return String(localized: "Harem", comment: "Manga genre")
        case .highStakesGame: return String(localized: "High Stakes Game", comment: "Manga genre")
        case .historical: return String(localized: "Historical", comment: "Manga genre")
        case .idolsFemale: return String(localized: "Idols (Female)", comment: "Manga genre")
        case .idolsMale: return String(localized: "Idols (Male)", comment: "Manga genre")
        case .isekai: return String(localized: "Isekai", comment: "Manga genre")
        case .iyashikei: return String(localized: "Iyashikei", comment: "Manga genre")
        case .lovePolygon: return String(localized: "Love Polygon", comment: "Manga genre")
        case .magicalSexShift: return String(localized: "Magical Sex Shift", comment: "Manga genre")
        case .mahouShoujo: return String(localized: "Mahou Shoujo", comment: "Manga genre")
        case .martialArts: return String(localized: "Martial Arts", comment: "Manga genre")
        case .mecha: return String(localized: "Mecha", comment: "Manga genre")
        case .medical: return String(localized: "Medical", comment: "Manga genre")
        case .memoir: return String(localized: "Memoir", comment: "Manga genre")
        case .military: return String(localized: "Military", comment: "Manga genre")
        case .music: return String(localized: "Music", comment: "Manga genre")
        case .mythology: return String(localized: "Mythology", comment: "Manga genre")
        case .organizedCrime: return String(localized: "Organized Crime", comment: "Manga genre")
        case .otakuCulture: return String(localized: "Otaku Culture", comment: "Manga genre")
        case .parody: return String(localized: "Parody", comment: "Manga genre")
        case .performingArts: return String(localized: "Performing Arts", comment: "Manga genre")
        case .pets: return String(localized: "Pets", comment: "Manga genre")
        case .psychological: return String(localized: "Psychological", comment: "Manga genre")
        case .racing: return String(localized: "Racing", comment: "Manga genre")
        case .reincarnation: return String(localized: "Reincarnation", comment: "Manga genre")
        case .reverseHarem: return String(localized: "Reverse Harem", comment: "Manga genre")
        case .loveStatusQuo: return String(localized: "Love Status Quo", comment: "Manga genre")
        case .samurai: return String(localized: "Samurai", comment: "Manga genre")
        case .school: return String(localized: "School", comment: "Manga genre")
        case .showbiz: return String(localized: "Showbiz", comment: "Manga genre")
        case .space: return String(localized: "Space", comment: "Manga genre")
        case .strategyGame: return String(localized: "Strategy Game", comment: "Manga genre")
        case .superPower: return String(localized: "Super Power", comment: "Manga genre")
        case .survival: return String(localized: "Survival", comment: "Manga genre")
        case .teamSports: return String(localized: "Team Sports", comment: "Manga genre")
        case .timeTravel: return String(localized: "Time Travel", comment: "Manga genre")
        case .vampire: return String(localized: "Vampire", comment: "Manga genre")
        case .videoGame: return String(localized: "Video Game", comment: "Manga genre")
        case .villainess: return String(localized: "Villainess", comment: "Manga genre")
        case .visualArts: return String(localized: "Visual Arts", comment: "Manga genre")
        case .workplace: return String(localized: "Workplace", comment: "Manga genre")
        case .urbanFantasy: return String(localized: "Urban Fantasy", comment: "Manga genre")
        case .unknown: return String(localized: "Unknown genre", comment: "Manga genre")
        }
    }
}
