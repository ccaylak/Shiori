import SwiftUI

struct GenresView: View {
    
    let genres: [MediaGenre]
    let mode: String
    
    var body: some View {
        if !genres.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink(destination: GenresListView(genres: genres, mode: mode)) {
                    LabelWithChevron(text: "Genres")
                }
                .buttonStyle(.plain)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(genres, id: \.self) { genre in
                            Text((Genre(rawValue: genre.name) ?? .unknown).displayName)
                                .font(.body)
                                .padding(9)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .scrollClipDisabled()
            }
            .padding(.horizontal)
        }
    }
}

private struct GenresListView: View {
    let genres: [MediaGenre]
    let mode: String
    
    var body: some View {
        List(genres, id: \.self) { genre in
            NavigationLink(
                destination: MediaGenresView(
                    genreId: genre.id,
                    mode: mode,
                    navigationTitle: (Genre(rawValue: genre.name) ?? .unknown).displayName
                ))
            {
                Text((Genre(rawValue: genre.name) ?? .unknown).displayName)
            }
        }
        .navigationTitle("Genres")
        .navigationBarTitleDisplayMode(.inline)
    }
}
