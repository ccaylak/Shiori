import SwiftUI

struct RecommendationsView: View {
    
    let recommendations: [MediaNode]
    
    var body: some View {
        if !recommendations.isEmpty {
            NavigationStack {
                VStack(alignment: .leading) {
                    NavigationLink(destination: RecommendationsListView(recommendations: recommendations)) {
                        HStack {
                            Text("Recommendations")
                                .font(.headline)
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
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
                                            .font(.caption2)
                                            .frame(width: 95, alignment: .leading)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                }
                                .buttonStyle(.plain)
                                
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollClipDisabled()
                }
            }
        }
    }
}

private struct RecommendationsListView: View {
    let recommendations: [MediaNode]
    
    var body: some View {
        ScrollView (.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(recommendations, id: \.node.id) { recommendation in
                    NavigationLink(destination: DetailsView(media: recommendation.node)) {
                        VStack(spacing: 2) {
                            ZStack(alignment: .topTrailing) {
                                AsyncImageView(imageUrl: recommendation.node.getCover)
                                    .frame(width: 150, height: 238)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                            }
                            .overlay(alignment: .topTrailing) {
                                if (recommendation.node.getScore > 0 && recommendation.node.getScore <= 10){
                                    HStack {
                                        Text("\(recommendation.node.getScore.formatted())")
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.white)
                                        
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.white)
                                    }
                                    .padding(4)
                                    .background(Material.ultraThin)
                                    .cornerRadius(12)
                                }
                            }
                            Text(recommendation.node.getTitle)
                                .frame(width: 150, alignment: .leading)
                                .font(.headline)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal)
            .navigationTitle("Recommendations")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
