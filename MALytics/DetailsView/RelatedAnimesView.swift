import SwiftUI

struct RelatedMediaView: View {
    
    let relatedMediaItems: [MediaNode]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Related Animes")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(relatedMediaItems, id: \.node.id) { relatedMedia in
                        NavigationLink(destination: DetailsView(media: relatedMedia.node)) {
                            VStack(alignment: .center) {
                                Text(relatedMedia.relationType ?? "")
                                AsyncImageView(imageUrl: relatedMedia.node.images.large)
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
    RelatedMediaView(relatedMediaItems: [MediaNode]())
}
