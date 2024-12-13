import Foundation

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

    static func formatDateStringWithLocale(_ dateString: String, fromFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = fromFormat
        dateFormatter.locale = Locale.current
        
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
}
