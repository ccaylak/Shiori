enum AiringTimeFormat: String, CaseIterable {
    case twelveHour
    case twentyFourHour
    
    var displayName: String {
        switch self {
        case .twelveHour: return String(localized: "12-hour Format", comment: "Time format")
        case .twentyFourHour: return String(localized: "24-hour Format", comment: "Time format")
        }
    }
}
