import SwiftUI

struct CharactersView: View {
    let characters: [Character]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading){
                NavigationLink(destination: CharactersListView(characters: characters)) {
                    HStack {
                        Text("Characters")
                            .font(.headline)
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(characters, id: \.id) { character in
                            VStack(alignment: .leading) {
                                AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                                    .frame(width: 60, height: 90)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                Text(character.metaData.name)
                                    .font(.caption)
                                    .frame(width: 60, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                }
                .scrollClipDisabled()
            }
        }
    }
}

private struct CharactersListView: View {
    let characters: [Character]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(characters, id: \.id) { character in
                    VStack {
                        AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                            .frame(width: 100, height: 156)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                            .overlay(alignment: .bottom) {
                                Text(character.role)
                                    .font(.caption2).bold()
                                    .foregroundStyle(.primary)
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        UnevenRoundedRectangle(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .blur(radius: 5)
                                    )
                                    .clipShape(
                                        UnevenRoundedRectangle(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
                                    )
                            }
                        
                        VStack (alignment: .leading){
                            Text(character.metaData.name)
                                .frame(width: 100, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.caption)
                                .bold()
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Characters")
        .navigationBarTitleDisplayMode(.inline)
    }
}
