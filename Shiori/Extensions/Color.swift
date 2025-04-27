import Foundation
import SwiftUI

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
            return .getByRGB(235, 101, 176)
        case "purple":
            return .purple
        default:
            return .blue
        }
    }
    
    static func getByRGB(_ r: Double, _ g: Double, _ b: Double) -> Color {
        return Color(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0
        )
    }
}
