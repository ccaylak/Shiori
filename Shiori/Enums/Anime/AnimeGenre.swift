import Foundation

enum AnimeGenre: String, Equatable {
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
    case scifi = "Sci-Fi"
    case sliceOfLife = "Slice of Life"
    case sports = "Sports"
    case supernatural = "Supernatural"
    case suspense = "Suspense"
    case ecchi = "Ecchi"
    case erotica = "Erotica"
    case hentai = "Hentai"
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
    case magicalSexShift = "Magical Sex Shift"
    case mahouShoujo = "Mahou Shoujo"
    case martialArts = "Martial Arts"
    case mecha = "Mecha"
    case medical = "Medical"
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
    case loveStatusQuo = "Love Status Quo"
    case samurai = "Samurai"
    case school = "School"
    case showbiz = "Showbiz"
    case space = "Space"
    case strategyGame = "Strategy Game"
    case superPower = "Super Power"
    case survival = "Survival"
    case teamSports = "Team Sports"
    case timeTravel = "Time Travel"
    case vampire = "Vampire"
    case videoGame = "Video Game"
    case visualArts = "Visual Arts"
    case workplace = "Workplace"
    case urbanFantasy = "Urban Fantasy"
    case villainess = "Villainess"
    case josei = "Josei"
    case kids = "Kids"
    case seinen = "Seinen"
    case shoujo = "Shoujo"
    case shounen = "Shounen"
    case unknown = "Unknown"
    
    var displayName: String {
        switch self {
        case .action: String(localized: "Action", comment: "Anime genre")
        case .adventure: String(localized: "Adventure", comment: "Anime genre")
        case .avantGarde: String(localized: "Avant Garde", comment: "Anime genre")
        case .awardWinning: String(localized: "Award Winning", comment: "Anime genre")
        case .boysLove: String(localized: "Boys Love", comment: "Anime genre")
        case .comedy: String(localized: "Comedy", comment: "Anime genre")
        case .drama: String(localized: "Drama", comment: "Anime genre")
        case .fantasy: String(localized: "Fantasy", comment: "Anime genre")
        case .girlsLove: String(localized: "Girls Love", comment: "Anime genre")
        case .gourmet: String(localized: "Gourmet", comment: "Anime genre")
        case .horror: String(localized: "Horror", comment: "Anime genre")
        case .mystery: String(localized: "Mystery", comment: "Anime genre")
        case .romance: String(localized: "Romance", comment: "Anime genre")
        case .scifi: String(localized: "Sci-Fi", comment: "Anime genre")
        case .sliceOfLife: String(localized: "Slice of Life", comment: "Anime genre")
        case .sports: String(localized: "Sports", comment: "Anime genre")
        case .supernatural: String(localized: "Supernatural", comment: "Anime genre")
        case .suspense: String(localized: "Suspense", comment: "Anime genre")
        case .ecchi: String(localized: "Ecchi", comment: "Anime genre")
        case .erotica: String(localized: "Erotica", comment: "Anime genre")
        case .hentai: String(localized: "Hentai", comment: "Anime genre")
        case .adultCast: String(localized: "Adult Cast", comment: "Anime genre")
        case .anthropomorphic: String(localized: "Anthropomorphic", comment: "Anime genre")
        case .cgdct: String(localized: "CGDCT", comment: "Anime genre")
        case .childcare: String(localized: "Childcare", comment: "Anime genre")
        case .combatSports: String(localized: "Combat Sports", comment: "Anime genre")
        case .crossdressing: String(localized: "Crossdressing", comment: "Anime genre")
        case .delinquents: String(localized: "Delinquents", comment: "Anime genre")
        case .detective: String(localized: "Detective", comment: "Anime genre")
        case .educational: String(localized: "Educational", comment: "Anime genre")
        case .gagHumor: String(localized: "Gag Humor", comment: "Anime genre")
        case .gore: String(localized: "Gore", comment: "Anime genre")
        case .harem: String(localized: "Harem", comment: "Anime genre")
        case .highStakesGame: String(localized: "High Stakes Game", comment: "Anime genre")
        case .historical: String(localized: "Historical", comment: "Anime genre")
        case .idolsFemale: String(localized: "Idols (Female)", comment: "Anime genre")
        case .idolsMale: String(localized: "Idols (Male)", comment: "Anime genre")
        case .isekai: String(localized: "Isekai", comment: "Anime genre")
        case .iyashikei: String(localized: "Iyashikei", comment: "Anime genre")
        case .lovePolygon: String(localized: "Love Polygon", comment: "Anime genre")
        case .magicalSexShift: String(localized: "Magical Sex Shift", comment: "Anime genre")
        case .mahouShoujo: String(localized: "Mahou Shoujo", comment: "Anime genre")
        case .martialArts: String(localized: "Martial Arts", comment: "Anime genre")
        case .mecha: String(localized: "Mecha", comment: "Anime genre")
        case .medical: String(localized: "Medical", comment: "Anime genre")
        case .military: String(localized: "Military", comment: "Anime genre")
        case .music: String(localized: "Music", comment: "Anime genre")
        case .mythology: String(localized: "Mythology", comment: "Anime genre")
        case .organizedCrime: String(localized: "Organized Crime", comment: "Anime genre")
        case .otakuCulture: String(localized: "Otaku Culture", comment: "Anime genre")
        case .parody: String(localized: "Parody", comment: "Anime genre")
        case .performingArts: String(localized: "Performing Arts", comment: "Anime genre")
        case .pets: String(localized: "Pets", comment: "Anime genre")
        case .psychological: String(localized: "Psychological", comment: "Anime genre")
        case .racing: String(localized: "Racing", comment: "Anime genre")
        case .reincarnation: String(localized: "Reincarnation", comment: "Anime genre")
        case .reverseHarem: String(localized: "Reverse Harem", comment: "Anime genre")
        case .loveStatusQuo: String(localized: "Love Status Quo", comment: "Anime genre")
        case .samurai: String(localized: "Samurai", comment: "Anime genre")
        case .school: String(localized: "School", comment: "Anime genre")
        case .showbiz: String(localized: "Showbiz", comment: "Anime genre")
        case .space: String(localized: "Space", comment: "Anime genre")
        case .strategyGame: String(localized: "Strategy Game", comment: "Anime genre")
        case .superPower: String(localized: "Super Power", comment: "Anime genre")
        case .survival: String(localized: "Survival", comment: "Anime genre")
        case .teamSports: String(localized: "Team Sports", comment: "Anime genre")
        case .timeTravel: String(localized: "Time Travel", comment: "Anime genre")
        case .vampire: String(localized: "Vampire", comment: "Anime genre")
        case .videoGame: String(localized: "Video Game", comment: "Anime genre")
        case .visualArts: String(localized: "Visual Arts", comment: "Anime genre")
        case .workplace: String(localized: "Workplace", comment: "Anime genre")
        case .urbanFantasy: String(localized: "Urban Fantasy", comment: "Anime genre")
        case .villainess: String(localized: "Villainess", comment: "Anime genre")
        case .josei: String(localized: "Josei", comment: "Anime genre")
        case .kids: String(localized: "Kids", comment: "Anime genre")
        case .seinen: String(localized: "Seinen", comment: "Anime genre")
        case .shoujo: String(localized: "Shoujo", comment: "Anime genre")
        case .shounen: String(localized: "Shounen", comment: "Anime genre")
        case .unknown: String(localized: "Unknown")
        }
    }
}
