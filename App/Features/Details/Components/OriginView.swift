import SwiftUI

struct OriginView: View {
    @Environment(MALDependencies.self)
    private var malDependencies
    
    let relations: [RelationEntry]
    
    @State private var results: [MediaNode] = []
    
    var body: some View {
        if !relations.isEmpty {
            VStack(alignment: .leading) {
                Text(relations[0].type == "anime" ? "Anime" : "Manga")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(results, id: \.id) { media in
                            NavigationLink(destination: DetailsView(media: media)) {
                                VStack(alignment: .leading) {
                                    AsyncImageView(imageUrl: media.mainPicture.largeUrl)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(10)
                                        .strokedBorder()
                                    
                                    Text(media.title)
                                        .font(.caption)
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollClipDisabled()
            }
            .onAppear {
                guard results.isEmpty else { return }
                
                Task {
                    for relation in relations {
                        do {
                            let fetched: MediaNode
                            if relation.type == "manga" {
                                fetched = try await malDependencies.mangaController.fetchDetails(id: relation.malId)
                            } else {
                                fetched = try await malDependencies.animeController.fetchDetails(id: relation.malId)
                            }
                            
                            results.append(fetched)
                            
                            try await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
                        } catch {
                            print("Fehler beim Laden von ID \(relation.malId): \(error)")
                        }
                    }
                }
            }
        }
    }
}
