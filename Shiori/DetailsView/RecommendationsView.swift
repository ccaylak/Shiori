import SwiftUI

struct RecommendationsView: View {
    
    let recommendations: [MediaNode]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommendations")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(recommendations, id: \.node.id) { recommendation in
                        NavigationLink(destination: DetailsView(media: recommendation.node)) {
                            VStack {
                                AsyncImageView(imageUrl: recommendation.node.getCover)
                                    .frame(width: 95, height: 150)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                Text(recommendation.node.getTitle)
                                    .foregroundStyle(.primary)
                                    .frame(width: 95, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    RecommendationsView(recommendations: [MediaNode]())
}
