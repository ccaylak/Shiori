import SwiftUI

struct RecommendationsView: View {
    
    let recommendations: [AnimeNode]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommendations")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(recommendations, id: \.node.id) { recommendation in
                        NavigationLink(destination: DetailsView(anime: recommendation.node)) {
                            AsyncImageView(imageUrl: recommendation.node.images.large)
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .cornerRadius(12)
                        }
                        
                    }
                }
                .frame(height: 150)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    RecommendationsView(recommendations: [AnimeNode]())
}
