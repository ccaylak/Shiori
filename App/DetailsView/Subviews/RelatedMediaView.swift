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
                                    
                                    AsyncImageView(imageUrl: relatedMedia.node.getCover)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .cornerRadius(12)
                                        .strokedBorder()
                                        .showFullTitleContextMenu(relatedMedia.node.getTitle)
                                }
                                .padding(8)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .frame(height: 250)
                    .padding(.horizontal)
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
}
