import SwiftUI

struct RecommendationsView: View {
    
    let recommendations: [MediaNode]
    
    var body: some View {
        if !recommendations.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                NavigationLink(destination: RecommendationsListView(recommendations: recommendations)) {
                    LabelWithChevron(text: "Recommendations")
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(recommendations, id: \.node.id) { recommendation in
                            NavigationLink(destination: DetailsView(media: recommendation.node)) {
                                VStack {
                                    AsyncImageView(imageUrl: recommendation.node.getCover)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(12)
                                        .showFullTitleContextMenu(recommendation.node.getTitle)
                                        .strokedBorder()
                                        .overlay(alignment: .topTrailing) {
                                            if recommendation.node.getEntryStatus != .unknown {
                                                recommendation.node.getEntryStatus.libraryIcon
                                                    .padding(7)
                                                    .glassEffectOrMaterial()
                                                    .cornerRadius(12)
                                            }
                                        }
                                    
                                    Text(recommendation.node.getTitle)
                                        .font(.caption2)
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
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
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Recommendations")
        .toolbarTitleDisplayMode(.inline)
    }
}
