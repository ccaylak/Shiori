import Foundation

enum Genre: String {
    case action = "Action"
    case adultCast = "Adult Cast"
    case adventure = "Adventure"
    case anthropomorphic = "Anthropomorphic"
    case awardWinning = "Award Winning"
    case avantGarde = "Avant Garde"
    case boysLove = "Boys Love"
    case cgdct = "CGDCT"
    case childcare = "Childcare"
    case combatSports = "Combat Sports"
    case comedy = "Comedy"
    case crossdressing = "Crossdressing"
    case delinquents = "Delinquents"
    case detective = "Detective"
    case drama = "Drama"
    case ecchi = "Ecchi"
    case educational = "Educational"
    case erotica = "Erotica"
    case fantasy = "Fantasy"
    case gagHumor = "Gag Humor"
    case girlsLove = "Girls Love"
    case gourmet = "Gourmet"
    case gore = "Gore"
    case harem = "Harem"
    case hentai = "Hentai"
    case highStakesGame = "High Stakes Game"
    case historical = "Historical"
    case horror = "Horror"
    case idolsFemale = "Idols (Female)"
    case idolsMale = "Idols (Male)"
    case isekai = "Isekai"
    case iyashikei = "Iyashikei"
    case josei = "Josei"
    case kids = "Kids"
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
    case mystery = "Mystery"
    case organizedCrime = "Organized Crime"
    case otakuCulture = "Otaku Culture"
    case parody = "Parody"
    case performingArts = "Performing Arts"
    case pets = "Pets"
    case psychological = "Psychological"
    case racing = "Racing"
    case reincarnation = "Reincarnation"
    case reverseHarem = "Reverse Harem"
    case romance = "Romance"
    case samurai = "Samurai"
    case school = "School"
    case sciFi = "Sci-Fi"
    case seinen = "Seinen"
    case shoujo = "Shoujo"
    case shounen = "Shounen"
    case showbiz = "Showbiz"
    case sliceOfLife = "Slice of Life"
    case space = "Space"
    case sports = "Sports"
    case strategyGame = "Strategy Game"
    case superPower = "Super Power"
    case supernatural = "Supernatural"
    case suspense = "Suspense"
    case survival = "Survival"
    case teamSports = "Team Sports"
    case timeTravel = "Time Travel"
    case urbanFantasy = "Urban Fantasy"
    case unknown = "Unknown genre"
    case vampire = "Vampire"
    case videoGame = "Video Game"
    case villainess = "Villainess"
    case visualArts = "Visual Arts"
    case workplace = "Workplace"
    
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
        case .ecchi: return String(localized: "Ecchi", comment: "Genre")
        case .erotica: return String(localized: "Erotica", comment: "Genre")
        case .hentai: return String(localized: "Hentai", comment: "Genre")
        case .josei: return String(localized: "Josei", comment: "Genre")
        case .kids: return String(localized: "Kids", comment: "Genre")
        case .seinen: return String(localized: "Seinen", comment: "Genre")
        case .shoujo: return String(localized: "Shoujo", comment: "Genre")
        case .shounen: return String(localized: "Shounen", comment: "Genre")
        case .adultCast: return String(localized: "Adult Cast", comment: "Genre")
        case .anthropomorphic: return String(localized: "Anthropomorphic", comment: "Genre")
        case .cgdct: return String(localized: "CGDCT", comment: "Genre")
        case .childcare: return String(localized: "Childcare", comment: "Genre")
        case .combatSports: return String(localized: "Combat Sports", comment: "Genre")
        case .crossdressing: return String(localized: "Crossdressing", comment: "Genre")
        case .delinquents: return String(localized: "Delinquents", comment: "Genre")
        case .detective: return String(localized: "Detective", comment: "Genre")
        case .educational: return String(localized: "Educational", comment: "Genre")
        case .gagHumor: return String(localized: "Gag Humor", comment: "Genre")
        case .gore: return String(localized: "Gore", comment: "Genre")
        case .harem: return String(localized: "Harem", comment: "Genre")
        case .highStakesGame: return String(localized: "High Stakes Game", comment: "Genre")
        case .historical: return String(localized: "Historical", comment: "Genre")
        case .idolsFemale: return String(localized: "Idols (Female)", comment: "Genre")
        case .idolsMale: return String(localized: "Idols (Male)", comment: "Genre")
        case .isekai: return String(localized: "Isekai", comment: "Genre")
        case .iyashikei: return String(localized: "Iyashikei", comment: "Genre")
        case .lovePolygon: return String(localized: "Love Polygon", comment: "Genre")
        case .magicalSexShift: return String(localized: "Magical Sex Shift", comment: "Genre")
        case .mahouShoujo: return String(localized: "Mahou Shoujo", comment: "Genre")
        case .martialArts: return String(localized: "Martial Arts", comment: "Genre")
        case .mecha: return String(localized: "Mecha", comment: "Genre")
        case .medical: return String(localized: "Medical", comment: "Genre")
        case .memoir: return String(localized: "Memoir", comment: "Genre")
        case .military: return String(localized: "Military", comment: "Genre")
        case .music: return String(localized: "Music", comment: "Genre")
        case .mythology: return String(localized: "Mythology", comment: "Genre")
        case .organizedCrime: return String(localized: "Organized Crime", comment: "Genre")
        case .otakuCulture: return String(localized: "Otaku Culture", comment: "Genre")
        case .parody: return String(localized: "Parody", comment: "Genre")
        case .performingArts: return String(localized: "Performing Arts", comment: "Genre")
        case .pets: return String(localized: "Pets", comment: "Genre")
        case .psychological: return String(localized: "Psychological", comment: "Genre")
        case .racing: return String(localized: "Racing", comment: "Genre")
        case .reincarnation: return String(localized: "Reincarnation", comment: "Genre")
        case .reverseHarem: return String(localized: "Reverse Harem", comment: "Genre")
        case .loveStatusQuo: return String(localized: "Love Status Quo", comment: "Genre")
        case .samurai: return String(localized: "Samurai", comment: "Genre")
        case .school: return String(localized: "School", comment: "Genre")
        case .showbiz: return String(localized: "Showbiz", comment: "Genre")
        case .space: return String(localized: "Space", comment: "Genre")
        case .strategyGame: return String(localized: "Strategy Game", comment: "Genre")
        case .superPower: return String(localized: "Super Power", comment: "Genre")
        case .survival: return String(localized: "Survival", comment: "Genre")
        case .teamSports: return String(localized: "Team Sports", comment: "Genre")
        case .timeTravel: return String(localized: "Time Travel", comment: "Genre")
        case .vampire: return String(localized: "Vampire", comment: "Genre")
        case .videoGame: return String(localized: "Video Game", comment: "Genre")
        case .villainess: return String(localized: "Villainess", comment: "Genre")
        case .visualArts: return String(localized: "Visual Arts", comment: "Genre")
        case .workplace: return String(localized: "Workplace", comment: "Genre")
        case .urbanFantasy: return String(localized: "Urban Fantasy", comment: "Genre")
        case .unknown: return String(localized: "Unknown genre", comment: "Genre")
        }
    }
}
