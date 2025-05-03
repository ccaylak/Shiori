import SwiftUI

struct GenresView: View {
    
    let genres: [Genre]
    
    var body: some View {
        if !genres.isEmpty {
            VStack(alignment: .leading) {
                Text("Genres")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre.displayName)
                                .font(.caption)
                                .padding(9)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(12)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    GenresView(genres: [.action, .shoujo, .adultCast, .seinen, .anthropomorphic])
}
