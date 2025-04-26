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
                        ForEach(genres, id: \.id) { genre in
                            Text(genre.name)
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
    GenresView(genres: [
        Genre(id: 1, name: "Horror"),
        Genre(id: 2, name: "Shonen"),
        Genre(id: 3, name: "Seinen"),
        Genre(id: 4, name: "Psycho"),
        Genre(id: 5, name: "Shojo"),
        Genre(id: 6, name: "Error"),
        Genre(id: 7, name: "Deep")
    ])
}
