import SwiftUI

enum CoverSize {
    case small, medium, large, extraLarge

    var size: CGSize {
        switch self {
        case .small:
            return CGSize(width: 70, height: 110)
        case .medium:
            return CGSize(width: 95, height: 150)
        case .large:
            return CGSize(width: 120, height: 180)
        case .extraLarge:
            return CGSize(width: 159, height: 250)
        }
    }
}
