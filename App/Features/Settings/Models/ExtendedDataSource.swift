enum ExtendedDataSource: String, CaseIterable {
    case jikan
    case tenrai

    var displayName: String {
        switch self {
        case .jikan:
            return "Jikan"
        case .tenrai:
            return "Tenrai (Experimental)"
        }
    }

    var baseURL: String {
        switch self {
        case .jikan:
            return "https://api.jikan.moe/v4"
        case .tenrai:
            return "https://api.tenrai.org/v1"
        }
    }

    var supportsProfileExtras: Bool {
        switch self {
        case .jikan:
            return true
        case .tenrai:
            return false
        }
    }
}
