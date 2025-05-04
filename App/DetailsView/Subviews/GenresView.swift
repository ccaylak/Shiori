import SwiftUI

struct GenresView: View {
    
    let genres: [Genre]
    
    var body: some View {
        if !genres.isEmpty {
            NavigationStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: GenresListView(genres: genres)) {
                        HStack {
                            Text("Genres")
                                .font(.headline)
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(genres, id: \.self) { genre in
                                Text(genre.displayName)
                                    .font(.caption)
                                    .padding(9)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(12)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                    .scrollClipDisabled()
                }
            }
        }
    }
}

private struct GenresListView: View {
    let genres: [Genre]
    
    var body: some View {
        List {
            ForEach(genres, id: \.self) { genre in
                Text(genre.displayName)
            }
            .navigationTitle("Genres")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
