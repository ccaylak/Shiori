import SwiftUI

struct CharactersView: View {
    let characters: [CharacterData]
    let seriesType: SeriesType
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 5) {
            LabelWithChevron(text: "Characters")
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(
                        seriesType == .anime
                        ? characters.sorted { ($0.favorites ?? 0) > ($1.favorites ?? 0) }
                        : characters,
                        id: \.id
                    ) { character in
                        NavigationLink(destination: CharacterDetailsView(characterData: character.character, role: character.role)) {
                            VStack(alignment: .leading) {
                                AsyncImageView(imageUrl: character.character.images.jpgImage.baseImage)
                                    .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                    .cornerRadius(12)
                                    .showFullTitleContextMenu(character.character.preferredNameFormat)
                                    .strokedBorder()
                                
                                Text(character.character.preferredNameFormat)
                                    .font(.caption)
                                    .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .scrollClipDisabled()
        }
        .padding(.bottom)
        .isVisible(!characters.isEmpty)
    }
}
