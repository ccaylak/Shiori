import SwiftUI

struct GeneralInformationView: View {
    
    let mediaType: String
    let episodes: Int
    let startDate: String
    let endDate: String
    let studios: [Studio]
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("General information")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Text("\(mediaType.capitalized),")
                    Text(formatEpisodes(episodes))
                }.font(.body)
                
                Text(formatReleaseRange(startDate: startDate, endDate: endDate) ?? "")
                    .font(.body)
                
                HStack(spacing: 5) {
                    Text("Made by:")
                        .bold()
                    ForEach(studios, id: \.id) {studio in
                        Text(studio.name)
                    }
                }
                
                
            }.padding(.bottom, 10)
        }
    }
    
    func formatEpisodes(_ episodes: Int) -> String {
        switch episodes {
        case 0:
            return "unknown"
        case 1:
            return "1 episode"
        default:
            return "\(episodes) episodes"
        }
    }
    
    func formatReleaseRange(startDate: String, endDate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        
        var startFormatted: String? = nil
        if !startDate.isEmpty, let start = dateFormatter.date(from: startDate) {
            startFormatted = outputFormatter.string(from: start)
        }
        
        var endFormatted: String? = nil
        if !endDate.isEmpty, let end = dateFormatter.date(from: endDate) {
            endFormatted = outputFormatter.string(from: end)
        }
        
        if let start = startFormatted, let end = endFormatted {
            return "\(start) - \(end)"
        } else if let start = startFormatted {
            return start
        } else {
            return nil
        }
    }
}

#Preview {
    let exampleStudios: [Studio] = [
        Studio(id: 1, name: "Netflix"),
        Studio(id: 2, name: "Amazon")
    ]
    
    GeneralInformationView(mediaType: "TV", episodes: 10, startDate: "2024-10-10", endDate: "2025-10-10", studios: exampleStudios)
}
