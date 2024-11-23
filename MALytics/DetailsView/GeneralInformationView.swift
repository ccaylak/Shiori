import SwiftUI

struct GeneralInformationView: View {
    
    let typeString: String
    let episodes: Int
    let startDate: String
    let endDate: String
    let studios: [Studio]
    let statusString: String
    
    private var type: MediaType {
        MediaType(rawValue: typeString) ?? .unknown
    }
    
    private var status: AiringStatus {
        AiringStatus(rawValue: statusString) ?? .unknown
    }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("General information")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                
                Text(formatTypeAndEpisodes(type: type, episodes: episodes))
                .font(.body)
                
                Text(formatReleaseRange(startDate: startDate, endDate: endDate, status: status) ?? "")
                        .font(.body)
                
                if (!studios.isEmpty) {
                    HStack(spacing: 5) {
                        Text("Made by")
                            .bold()
                        ForEach(studios, id: \.id) {studio in
                            Text(studio.name)
                        }
                    }
                } else {
                    Text("Unknown animation studio")
                }
                
                
            }.padding(.bottom, 10)
        }
    }
    
    func formatTypeAndEpisodes(type: MediaType, episodes: Int) -> String {
    
        if (episodes == 1 && type == .movie) {
            return type.displayName
        }
        if (episodes > 1 && type == .movie) {
            return "\(type.displayName), \(episodes) parts"
        }
        
        if (episodes == 0 && type == .tv) {
            return type.displayName
        }

        return "\(type.displayName), \(episodes) episodes"
    }
    
    func formatReleaseRange(startDate: String, endDate: String, status: AiringStatus) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        
        let startFormatted = startDate.isEmpty ? nil : dateFormatter.date(from: startDate).flatMap { outputFormatter.string(from: $0) }
        let endFormatted = endDate.isEmpty ? nil : dateFormatter.date(from: endDate).flatMap { outputFormatter.string(from: $0) }
        
        switch status {
        case .finishedAiring where startFormatted != nil && endFormatted != nil && startFormatted == endFormatted:
            return "Aired in \(startFormatted!)"
        case .finishedAiring where startFormatted != nil && endFormatted != nil:
            return "Aired from \(startFormatted!) - \(endFormatted!)"
        case .currentlyAiring where startFormatted != nil:
            return "Airing since \(startFormatted!)"
        case .notYetAired where startFormatted != nil:
            return "Will air in \(startFormatted!)"
        case .notYetAired where startFormatted == nil && endFormatted == nil:
            return "Unkown release date"
        default:
            return nil
        }
    }
}

#Preview {
    let exampleStudios: [Studio] = [
        Studio(id: 1, name: "Netflix"),
        Studio(id: 2, name: "Amazon")
    ]
    
    GeneralInformationView(typeString: "tv", episodes: 10, startDate: "2024-10-10", endDate: "2025-10-10", studios: exampleStudios, statusString: "currently_airing")
}
