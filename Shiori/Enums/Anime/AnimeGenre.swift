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
        case .action: String(localized: "Action")
        case .adventure: String(localized: "Adventure")
        case .avantGarde: String(localized: "Avant Garde")
        case .awardWinning: String(localized: "Award Winning")
        case .boysLove: String(localized: "Boys Love")
        case .comedy: String(localized: "Comedy")
        case .drama: String(localized: "Drama")
        case .fantasy: String(localized: "Fantasy")
        case .girlsLove: String(localized: "Girls Love")
        case .gourmet: String(localized: "Gourmet")
        case .horror: String(localized: "Horror")
        case .mystery: String(localized: "Mystery")
        case .romance: String(localized: "Romance")
        case .scifi: String(localized:"Sci-Fi")
        case .sliceOfLife: String(localized: "Slice of Life")
        case .sports: String(localized:"Sports")
        case .supernatural: String(localized:"Supernatural")
        case .suspense: String(localized:"Suspense")
        case .ecchi: String(localized:"Ecchi")
        case .erotica: String(localized:"Erotica")
        case .hentai: String(localized:"Hentai")
        case .adultCast: String(localized:"Adult Cast")
        case .anthropomorphic: String(localized:"Anthropomorphic")
        case .cgdct: String(localized:"CGDCT")
        case .childcare: String(localized:"Childcare")
        case .combatSports: String(localized:"Combat Sports")
        case .crossdressing: String(localized:"Crossdressing")
        case .delinquents: String(localized:"Delinquents")
        case .detective: String(localized:"Detective")
        case .educational: String(localized:"Educational")
        case .gagHumor: String(localized:"Gag Humor")
        case .gore: String(localized:"Gore")
        case .harem: String(localized:"Harem")
        case .highStakesGame: String(localized:"High Stakes Game")
        case .historical: String(localized:"Historical")
        case .idolsFemale: String(localized:"Idols (Female)")
        case .idolsMale: String(localized:"Idols (Male)")
        case .isekai: String(localized:"Isekai")
        case .iyashikei: String(localized:"Iyashikei")
        case .lovePolygon: String(localized:"Love Polygon")
        case .magicalSexShift: String(localized:"Magical Sex Shift")
        case .mahouShoujo: String(localized:"Mahou Shoujo")
        case .martialArts: String(localized:"Martial Arts")
        case .mecha: String(localized:"Mecha")
        case .medical: String(localized:"Medical")
        case .military: String(localized:"Military")
        case .music: String(localized:"Music")
        case .mythology: String(localized:"Mythology")
        case .organizedCrime: String(localized:"Organized Crime")
        case .otakuCulture: String(localized:"Otaku Culture")
        case .parody: String(localized:"Parody")
        case .performingArts: String(localized:"Performing Arts")
        case .pets: String(localized:"Pets")
        case .psychological: String(localized:"Psychological")
        case .racing: String(localized:"Racing")
        case .reincarnation: String(localized:"Reincarnation")
        case .reverseHarem: String(localized:"Reverse Harem")
        case .loveStatusQuo: String(localized:"Love Status Quo")
        case .samurai: String(localized:"Samurai")
        case .school: String(localized:"School")
        case .showbiz: String(localized:"Showbiz")
        case .space: String(localized:"Space")
        case .strategyGame: String(localized:"Strategy Game")
        case .superPower: String(localized:"Super Power")
        case .survival: String(localized:"Survival")
        case .teamSports: String(localized:"Team Sports")
        case .timeTravel: String(localized:"Time Travel")
        case .vampire: String(localized:"Vampire")
        case .videoGame: String(localized:"Video Game")
        case .visualArts: String(localized:"Visual Arts")
        case .workplace: String(localized:"Workplace")
        case .urbanFantasy: String(localized:"Urban Fantasy")
        case .villainess: String(localized:"Villainess")
        case .josei: String(localized:"Josei")
        case .kids: String(localized:"Kids")
        case .seinen: String(localized:"Seinen")
        case .shoujo: String(localized:"Shoujo")
        case .shounen: String(localized:"Shounen")
        case .unknown: String(localized:"Unknown")
        }
    }
}
