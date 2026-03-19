import SwiftUI

struct RelatedMediaView: View {
    
    let media: MediaNode
    let seriesType: SeriesType
    
    private let priorityTypes: [Related] = [.prequel, .sequel, .sideStory]
    
    private var relevantItems: [Media] {
        switch seriesType {
        case .anime:
            return media.relatedAnime ?? []
        case .manga:
            return media.relatedManga ?? []
        case .unknown:
            return []
        }
    }
    
    private var sortedMediaItems: [Media] {
        guard relevantItems.contains(where: { priorityTypes.contains($0.getRelationType) }) else {
            return relevantItems
        }
        
        let prioritized = relevantItems.filter { priorityTypes.contains($0.getRelationType) }
        let nonPrioritized = relevantItems.filter { !priorityTypes.contains($0.getRelationType) }
        
        let sortedPrioritized = priorityTypes.flatMap { type in
            prioritized.filter { $0.getRelationType == type }
        }
        return sortedPrioritized + nonPrioritized
    }
    
    var body: some View {
        if !relevantItems.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                LabelWithChevron(text: "Related")
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(sortedMediaItems, id: \.node.id) { relatedMedia in
                            NavigationLink(destination: DetailsView(media: relatedMedia.node)) {
                                VStack(alignment: .center) {
                                    Text(relatedMedia.relationTypeFormatted ?? "")
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .center)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .foregroundColor(.accentColor)
                                    
                                    AsyncImageView(imageUrl: relatedMedia.node.mainPicture.largeUrl)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(12)
                                        .strokedBorder()
                                        .showFullTitleContextMenu(relatedMedia.node.preferredTitle)
                                        .padding(.bottom, 2)
                                        .overlay(alignment: .topTrailing) {
                                            if relatedMedia.node.getEntryStatus != .unknown {
                                                relatedMedia.node.getEntryStatus.libraryIcon
                                                    .padding(7)
                                                    .glassEffectOrMaterial()
                                                    .cornerRadius(12)
                                            }
                                        }
                                    
                                    Text(relatedMedia.node.preferredTitle)
                                        .font(.caption)
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(8)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal)
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
}
