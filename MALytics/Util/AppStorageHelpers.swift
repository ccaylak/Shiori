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
    
    static func getByRGB(_ r: Double, _ g: Double, _ b: Double) -> Color {
        return Color(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0
        )
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

extension String {
    static func formatDates(startDate: String, endDate: String) -> (startFormatted: String?, endFormatted: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        
        let startFormatted = startDate.isEmpty ? nil : dateFormatter.date(from: startDate).flatMap { outputFormatter.string(from: $0) }
        let endFormatted = endDate.isEmpty ? nil : dateFormatter.date(from: endDate).flatMap { outputFormatter.string(from: $0) }
        
        return (startFormatted, endFormatted)
    }
}
