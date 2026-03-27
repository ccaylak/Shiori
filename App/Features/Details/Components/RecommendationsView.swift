import SwiftUI

struct RecommendationsView: View {
    
    let recommendations: [Media]
    
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
                                    AsyncImageView(imageUrl: recommendation.node.mainPicture.largeUrl)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(12)
                                        .showFullTitleContextMenu(recommendation.node.preferredTitle)
                                        .strokedBorder()
                                        .overlay(alignment: .topTrailing) {
                                            recommendation.node.getEntryStatus.libraryIcon
                                                .padding(7)
                                                .glassEffectOrMaterial()
                                                .cornerRadius(12)
                                                .isVisible(recommendation.node.getEntryStatus != .notSet)
                                        }
                                    Text(recommendation.node.preferredTitle)
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
    let recommendations: [Media]
    
    var body: some View {
        ScrollView (.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(recommendations, id: \.node.id) { recommendation in
                    NavigationLink(destination: DetailsView(media: recommendation.node)) {
                        VStack(spacing: 2) {
                            ZStack(alignment: .topTrailing) {
                                AsyncImageView(imageUrl: recommendation.node.mainPicture.largeUrl)
                                    .frame(width: 150, height: 238)
                                    .cornerRadius(12)
                            }
                            .overlay(alignment: .topTrailing) {
                                if let mean = recommendation.node.mean, mean > 0 {
                                    HStack {
                                        Text(mean.formatted())
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.white)
                                        
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.white)
                                    }
                                    .padding(7)
                                    .glassEffectOrMaterial()
                                    .cornerRadius(12)
                                }
                            }
                            Text(recommendation.node.preferredTitle)
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
