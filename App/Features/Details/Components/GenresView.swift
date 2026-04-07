import SwiftUI

struct GenresView: View {
    
    let genres: [MediaGenre]
    let mode: SeriesType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            NavigationLink(destination: GenresListView(genres: genres, mode: mode)) {
                LabelWithChevron(text: "Genres")
            }
            .buttonStyle(.plain)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(genres, id: \.self) { genre in
                        Text(MediaCategory(name: genre.name).displayName)
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
        .isVisible(!genres.isEmpty)
    }
}

private struct GenresListView: View {
    let genres: [MediaGenre]
    let mode: SeriesType
    
    private var groupedGenres: [(title: String, items: [MediaGenre])] {
        let grouped = Dictionary(grouping: genres) { genre in
            MediaCategory(name: genre.name).sectionTitle
        }
        
        let order = [
            String(localized: "Demographics"),
            String(localized: "Explicit Genres"),
            String(localized: "Genres"),
            String(localized: "Themes"),
            String(localized: "Other")
        ]
        
        return order.compactMap { title in
            guard let items = grouped[title] else { return nil }
            return (title, items)
        }
    }
    
    var body: some View {
        List {
            ForEach(groupedGenres, id: \.title) { group in
                Section {
                    ForEach(group.items, id: \.self) { genre in
                        let mediaCategory = MediaCategory(name: genre.name)
                        
                        NavigationLink(
                            destination: MediaGenresView(
                                genreId: genre.id,
                                mode: mode,
                                navigationTitle: mediaCategory.displayName
                            )
                        ) {
                            Text(mediaCategory.displayName)
                        }
                    }
                } header: {
                    Text(group.title)
                }
            }
        }
        .navigationTitle("Genres")
        .navigationBarTitleDisplayMode(.inline)
    }
}
