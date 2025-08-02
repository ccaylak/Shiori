import SwiftUI

struct OriginView: View {
    
    let mangaController = MangaController()
    let animeController = AnimeController()
    
    let relations: [RelationEntry]
    
    @State private var results: [Media] = []
    
    var body: some View {
        if !relations.isEmpty {
            VStack(alignment: .leading) {
                Text(relations[0].type == "anime" ? "Adaption" : "Source")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(results, id: \.id) { media in
                            NavigationLink(destination: DetailsView(media: media)) {
                                VStack(alignment: .leading) {
                                    AsyncImageView(imageUrl: media.getCover)
                                        .frame(width: 120, height: 180)
                                        .cornerRadius(10)
                                        .strokedBorder()
                                    
                                    Text(media.getTitle)
                                        .font(.caption)
                                        .frame(width: 120, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }.buttonStyle(.plain)
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
                            let fetched: Media
                            if relation.type == "manga" {
                                fetched = try await mangaController.fetchDetails(id: relation.malId)
                            } else {
                                fetched = try await animeController.fetchDetails(id: relation.malId)
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
