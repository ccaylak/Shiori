import Foundation

enum RatingValues: Int, CaseIterable {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    
    var displayName: String {
        switch self {
        case .zero : return String(localized: "Not rated yet")
        case .one: return String(localized: "1 (Appalling)")
        case .two: return String(localized: "2 (Horrible)")
        case .three: return String(localized: "3 (Very bad)")
        case .four: return String(localized: "4 (Bad)")
        case .five: return String(localized: "5 (Average)")
        case .six: return String(localized: "6 (Fine)")
        case .seven: return String(localized: "7 (Good)")
        case .eight: return String(localized: "8 (Very good)")
        case .nine: return String(localized: "9 (Great)")
        case .ten: return String(localized: "10 (Masterpiece)")
        }
    }
}
