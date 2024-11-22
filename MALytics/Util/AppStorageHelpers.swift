import Foundation
import SwiftUICore

extension Color {
    static func getByColorString(_ colorString: String) -> Color {
        switch colorString {
        case "blue":
            return .blue
        case "red":
            return .red
        case "orange":
            return .orange
        case "pink":
            return .pink
        case "purple":
            return .purple
        default:
            return .blue
        }
    }
}

extension ColorScheme {
    static func getByColorSchemeString(_ colorSchemeName: String) -> ColorScheme? {
        switch colorSchemeName {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }
}
