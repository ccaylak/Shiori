enum AiringNotificationTiming: String, CaseIterable {
    case airing
    case fifteenMinutes
    case oneHour
    case sameDay
    
    var displayName: String {
        switch self {
            case .airing: return String(localized: "At airing time", comment: "Airing notification timing")
            case .fifteenMinutes: return String(localized: "15 minutes before", comment: "Airing notification timing")
            case .oneHour: return String(localized: "1 hour before", comment: "Airing notification timing")
            case .sameDay: return String(localized: "On the same day", comment: "Airing notification timing")
        }
    }
    
    var value: Int {
        switch self {
            case .airing: return 0
            case .fifteenMinutes: return 15
            case .oneHour: return 60
            case .sameDay: return 1000
        }
    }
}
