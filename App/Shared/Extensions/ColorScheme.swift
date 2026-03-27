import Foundation
import SwiftUI

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
