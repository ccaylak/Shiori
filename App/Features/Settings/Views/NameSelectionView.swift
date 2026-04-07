import SwiftUI

struct NameSelectionView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    @State private var jikanCharacters: JikanCharacter = JikanCharacter(data: [])
    let jikanCharacterController = JikanCharacterController()
    
    var body: some View {
        List {
            Section("Preview") {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(jikanCharacters.data, id: \.id) { character in
                            VStack {
                                AsyncImageView(imageUrl: character.character.images.jpgImage.baseImage)
                                    .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                    .cornerRadius(12)
                                    .strokedBorder()
                                
                                Text(character.character.preferredNameFormat)
                                    .font(.caption)
                                    .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                }.scrollClipDisabled()
            }
            
            Section {
                Picker("Format", systemImage: "textformat.characters.arrow.left.and.right", selection: $settingsManager.nameFormat) {
                   ForEach(NameFormat.allCases, id: \.self) { mode in
                       Text(mode.displayName)
                           .tag(mode)
                   }
                }
                .pickerStyle(.navigationLink)
            } footer: {
                Text(settingsManager.nameFormat.description)
            }
        }
        .navigationTitle("Name Format")
        .toolbarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                jikanCharacters = try await jikanCharacterController.fetchAnimeCharacter(id: 877)
            }
        }
    }
}
