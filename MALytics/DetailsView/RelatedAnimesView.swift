import SwiftUI

struct RelatedAnimesView: View {
    
    let relatedAnimes: [AnimeNode]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Related Animes")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(relatedAnimes, id: \.node.id) { relatedAnime in
                        NavigationLink(destination: DetailsView(anime: relatedAnime.node)) {
                            VStack(alignment: .center) {
                                Text(relatedAnime.relationType ?? "")
                                AsyncImageView(imageUrl: relatedAnime.node.images.large)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .cornerRadius(12)
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                        }
                    }
                }.frame(height: 250)
            }
        }
    }
}

#Preview {
    RelatedAnimesView(relatedAnimes: [AnimeNode]())
}
