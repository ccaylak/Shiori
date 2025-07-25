import SwiftUI

struct GenresView: View {
    
    let genres: [Genre]
    
    var body: some View {
        if !genres.isEmpty {
            VStack(alignment: .leading) {
                NavigationLink(destination: GenresListView(genres: genres)) {
                    HStack {
                        Text("Genres")
                            .font(.headline)
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.secondary)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(.plain)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre.displayName)
                                .font(.caption)
                                .padding(9)
                                .background(Color(.secondarySystemGroupedBackground))
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

private struct GenresListView: View {
    let genres: [Genre]
    @State private var sortingOptions = "Default"
    
    private var sortedGenres: [Genre] {
        switch sortingOptions {
        case "Title":
            return genres.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
        default:
            return genres
        }
    }
    
    var body: some View {
        NavigationStack {
            List(sortedGenres, id: \.self) { genre in
                Text(genre.displayName)
            }
            .navigationTitle("Genres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $sortingOptions) {
                            Label("Default", systemImage: "circle")
                                .tag("Default")
                            Label("Title", systemImage: "textformat.characters")
                                .tag("Title")
                        }
                    } label: {
                        Label("Sort", systemImage: "ellipsis")
                    }
                }
            }
        }
    }
}
