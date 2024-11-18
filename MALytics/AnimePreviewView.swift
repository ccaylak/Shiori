import SwiftUI

struct AnimeView: View {
    
    let title: String
    let image: String
    let episodes: Int
    let releaseYear: String
    let rating: Double
    let type: String
    
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(imageUrl: image)
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(type.capitalized), \(releaseYear)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(episodes) episodes")
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
}

#Preview {
    AnimeView(title: "Tokyo Ghoul", image: "https://cdn.myanimelist.net/images/manga/3/145997l.jpg", episodes: 12, releaseYear: "2021", rating: 6.19, type: "TV")
}
