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
        case .zero : return "Not rated yet"
        case .one: return "1 (Appalling)"
        case .two: return "2 (Horrible)"
        case .three: return "3 (Very bad)"
        case .four: return "4 (Bad)"
        case .five: return "5 (Average)"
        case .six: return "6 (Fine)"
        case .seven: return "7 (Good)"
        case .eight: return "8 (Very good)"
        case .nine: return "9 (Great)"
        case .ten: return "10 (Masterpiece)"
        }
    }
}
