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
        case .action: return String(localized: "Action")
        case .adventure: return String(localized: "Adventure")
        case .avantGarde: return String(localized: "Avant Garde")
        case .awardWinning: return String(localized: "Award Winning")
        case .boysLove: return String(localized: "Boys Love")
        case .comedy: return String(localized: "Comedy")
        case .drama: return String(localized: "Drama")
        case .fantasy: return String(localized: "Fantasy")
        case .girlsLove: return String(localized: "Girls Love")
        case .gourmet: return String(localized: "Gourmet")
        case .horror: return String(localized: "Horror")
        case .mystery: return String(localized: "Mystery")
        case .romance: return String(localized: "Romance")
        case .sciFi: return String(localized: "Sci-Fi")
        case .sliceOfLife: return String(localized: "Slice of Life")
        case .sports: return String(localized: "Sports")
        case .supernatural: return String(localized: "Supernatural")
        case .suspense: return String(localized: "Suspense")
        case .ecchi: return String(localized: "Ecchi")
        case .erotica: return String(localized: "Erotica")
        case .hentai: return String(localized: "Hentai")
        case .josei: return String(localized: "Josei")
        case .kids: return String(localized: "Kids")
        case .seinen: return String(localized: "Seinen")
        case .shoujo: return String(localized: "Shoujo")
        case .shounen: return String(localized: "Shounen")
        case .adultCast: return String(localized: "Adult Cast")
        case .anthropomorphic: return String(localized: "Anthropomorphic")
        case .cgdct: return String(localized: "CGDCT")
        case .childcare: return String(localized: "Childcare")
        case .combatSports: return String(localized: "Combat Sports")
        case .crossdressing: return String(localized: "Crossdressing")
        case .delinquents: return String(localized: "Delinquents")
        case .detective: return String(localized: "Detective")
        case .educational: return String(localized: "Educational")
        case .gagHumor: return String(localized: "Gag Humor")
        case .gore: return String(localized: "Gore")
        case .harem: return String(localized: "Harem")
        case .highStakesGame: return String(localized: "High Stakes Game")
        case .historical: return String(localized: "Historical")
        case .idolsFemale: return String(localized: "Idols (Female)")
        case .idolsMale: return String(localized: "Idols (Male)")
        case .isekai: return String(localized: "Isekai")
        case .iyashikei: return String(localized: "Iyashikei")
        case .lovePolygon: return String(localized: "Love Polygon")
        case .magicalSexShift: return String(localized: "Magical Sex Shift")
        case .mahouShoujo: return String(localized: "Mahou Shoujo")
        case .martialArts: return String(localized: "Martial Arts")
        case .mecha: return String(localized: "Mecha")
        case .medical: return String(localized: "Medical")
        case .memoir: return String(localized: "Memoir")
        case .military: return String(localized: "Military")
        case .music: return String(localized: "Music")
        case .mythology: return String(localized: "Mythology")
        case .organizedCrime: return String(localized: "Organized Crime")
        case .otakuCulture: return String(localized: "Otaku Culture")
        case .parody: return String(localized: "Parody")
        case .performingArts: return String(localized: "Performing Arts")
        case .pets: return String(localized: "Pets")
        case .psychological: return String(localized: "Psychological")
        case .racing: return String(localized: "Racing")
        case .reincarnation: return String(localized: "Reincarnation")
        case .reverseHarem: return String(localized: "Reverse Harem")
        case .loveStatusQuo: return String(localized: "Love Status Quo")
        case .samurai: return String(localized: "Samurai")
        case .school: return String(localized: "School")
        case .showbiz: return String(localized: "Showbiz")
        case .space: return String(localized: "Space")
        case .strategyGame: return String(localized: "Strategy Game")
        case .superPower: return String(localized: "Super Power")
        case .survival: return String(localized: "Survival")
        case .teamSports: return String(localized: "Team Sports")
        case .timeTravel: return String(localized: "Time Travel")
        case .vampire: return String(localized: "Vampire")
        case .videoGame: return String(localized: "Video Game")
        case .villainess: return String(localized: "Villainess")
        case .visualArts: return String(localized: "Visual Arts")
        case .workplace: return String(localized: "Workplace")
        case .urbanFantasy: return String(localized: "Urban Fantasy")
        case .unknown: return String(localized: "Unknown genre")
        }
    }
}
