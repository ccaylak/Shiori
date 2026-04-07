enum Related: String {
    case prequel = "Prequel"
    case sequel = "Sequel"
    case other = "Other"
    case spinOff = "Spin-off"
    case alternativeVersion = "Alternative version"
    case sideStory = "Side story"
    case adaptation = "Adaptation"
    case character = "Character"
    case alternativeSetting = "Alternative setting"
    case summary = "Summary"
    case unknown = "Unknown"
    case parentStory = "Parent story"
    case novel = "Novel"
    case fullStory = "Full story"
    
    var displayName: String {
        switch self {
        case .prequel: return String(localized: "Prequel", comment: "Relation type of detailview")
        case .sequel: return String(localized: "Sequel", comment: "Relation type of detailview")
        case .other: return String(localized: "Other", comment: "Relation type of detailview")
        case .spinOff: return String(localized: "Spin-Off", comment: "Relation type of detailview")
        case .fullStory: return String(localized: "Full Story", comment: "Relation type of detailview")
        case .alternativeVersion: return String(localized: "Alternative Version", comment: "Relation type of detailview")
        case .sideStory: return String(localized: "Side Story", comment: "Relation type of detailview")
        case .adaptation: return String(localized: "Adaptation", comment: "Relation type of detailview")
        case .character: return String(localized: "Character", comment: "Relation type of detailview")
        case .alternativeSetting: return String(localized: "Alternative Setting", comment: "Relation type of detailview")
        case .unknown: return String(localized: "Unknown relationtype", comment: "Relation type of detailview")
        case .summary: return String(localized: "Summary", comment: "Relation type of detailview")
        case .parentStory: return String(localized: "Parent Story", comment: "Relation type of detailview")
        case .novel: return String(localized: "Novel", comment: "Relation type of detailview")
        }
    }
}
