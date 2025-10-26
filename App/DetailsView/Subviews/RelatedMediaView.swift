import SwiftUI

struct RelatedMediaView: View {
    
    let media: Media
    let mediaType: MediaType
    
    private let priorityTypes: [Related] = [.prequel, .sequel, .sideStory]
    
    private var relevantItems: [MediaNode] {
        switch mediaType {
        case .anime:
            return media.relatedAnimes ?? []
        case .manga:
            return media.relatedMangas ?? []
        case .unknown:
            return []
        }
    }
    
    private var sortedMediaItems: [MediaNode] {
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
            VStack(alignment: .leading) {
                Text("Related")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(sortedMediaItems, id: \.node.id) { relatedMedia in
                            NavigationLink(destination: DetailsView(media: relatedMedia.node)) {
                                VStack(alignment: .center) {
                                    Text(relatedMedia.getRelationType.displayName)
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .center)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .foregroundColor(.accentColor)
                                    
                                    AsyncImageView(imageUrl: relatedMedia.node.getCover)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(12)
                                        .strokedBorder()
                                        .showFullTitleContextMenu(relatedMedia.node.getTitle)
                                        .padding(.bottom, 2)
                                        .overlay(alignment: .topTrailing) {
                                            if relatedMedia.node.getEntryStatus != .unknown {
                                                relatedMedia.node.getEntryStatus.libraryIcon
                                                    .padding(7)
                                                    .background(Material.ultraThin)
                                                    .cornerRadius(12)
                                            }
                                        }
                                    
                                    Text(relatedMedia.node.getTitle)
                                        .font(.caption)
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(8)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
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
