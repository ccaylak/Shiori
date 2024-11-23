import SwiftUI

struct MediaView: View {
    
    let title: String
    let image: String
    let episodes: Int
    let releaseYear: String
    let rating: Double
    let typeString: String
    let statusString: String
    
    private var type: MediaType {
        MediaType(rawValue: typeString) ?? .unknown
    }
    
    private var status: AiringStatus {
        AiringStatus(rawValue: statusString) ?? .unknown
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(formatTypeAndReleaseYear(type: type, releaseYear: releaseYear))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(formattedEpisodesWithStatus(episodes: episodes, status: status, type: type))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    func formatTypeAndReleaseYear(type: MediaType, releaseYear: String) -> String {
        
        if(type == .unknown && releaseYear == "Unknown") {
            return ""
        }
        
        if (type != .unknown && releaseYear == "Unknown") {
            return type.displayName
        }
        
        return "\(type.displayName), \(releaseYear)"
    }
    
    func formattedEpisodesWithStatus(episodes: Int, status: AiringStatus, type: MediaType) -> String {
        if(episodes == 0 && (status == .notYetAired || status == .currentlyAiring)) {
            return status.displayName
        }
        if (type == .movie) {
            if (episodes > 1) {
                return "\(episodes) parts"
            }
            return ""
        }
        if (type == .tvSpecial || type == .special) {
            if (episodes > 1) {
                return "\(episodes) episodes"
            }
            return ""
        }
        
        return "\(episodes) episodes (\(status.displayName))"
    }
}

#Preview {
    MediaView(title: "Tokyo Ghoul", image: "https://cdn.myanimelist.net/images/manga/3/145997l.jpg", episodes: 12, releaseYear: "2021", rating: 6.19, typeString: "tv", statusString: "finished_airing")
}
