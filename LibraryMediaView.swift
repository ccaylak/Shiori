import SwiftUI

struct LibraryMediaView: View {
    
    @AppStorage("appearance") private var appearance = Appearance.light
    
    let title: String
    let image: String
    let releaseYear: String
    let type: String
    let progressStatus: String
    let completedUnits: Int
    let totalUnits: Int
    
    var mediaType: Any? {
        if let mangaType = MangaType(rawValue: type) {
            return mangaType
        } else if let animeType = AnimeType(rawValue: type) {
            return animeType
        }
        
        return nil
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .lineLimit(3)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Text(formattedDetails(year: releaseYear))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text((progressStatus=="All") ? "" : progressStatus)
                Spacer()
                
                
                let safeTotalUnits = max(totalUnits, 1)
                let safeCompletedUnits = min(max(completedUnits, 1), safeTotalUnits)
                
                Gauge(value: Double(safeCompletedUnits), in: 1...Double(safeTotalUnits)) {
                } currentValueLabel: {
                    Text("\(Int(safeCompletedUnits))")
                } minimumValueLabel: {
                    Text("1")
                        .foregroundColor(Color.green)
                } maximumValueLabel: {
                    Text("\(safeTotalUnits)")
                        .foregroundColor(Color.red)
                }
                .gaugeStyle(.accessoryLinear)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((appearance == .dark) ? Color.gray.opacity(0.15) : Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
    }
    func formattedDetails(year: String) -> String {
        var formattedResult = ""
        if mediaType is MangaType{
            formattedResult = formattedMangaDetails(type: mediaType as! MangaType, year: year)
        } else if mediaType is AnimeType {
            formattedResult = formattedAnimeDetails(type: mediaType as! AnimeType, year: year)
        }
        return formattedResult
    }
    
    func formattedAnimeDetails(type: AnimeType, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedMangaDetails(type: MangaType, year: String) -> String {
        return "\(type.displayName), \(releaseYear)"
    }
}

#Preview {
    LibraryMediaView(title: "Tokyo Ghoul", image: "test", releaseYear: "2020-01-01", type: "manga", progressStatus: "Reading", completedUnits: 5, totalUnits: 10)
}
