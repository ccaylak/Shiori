import SwiftUI

struct CharacterDetailsView: View {
    
    let character: Character
    let role: String
    @State private var details: JikanCharacterFull? = nil
    @State private var isDescriptionExpanded = false
    @EnvironmentObject private var alertManager: AlertManager
    
    let jikanCharacterController = JikanCharacterController()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 8) {
                    AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                        .frame(width: 72*1.5, height: 108*1.5)
                        .cornerRadius(12)
                        .strokedBorder()
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text(details?.data.nameKanji ?? "")
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .font(.caption)
                            Spacer()
                            
                            if let favorites = details?.data.favorites, favorites > 0 {
                                HStack(alignment: .center) {
                                    Image(systemName: "heart")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    
                                    Text("\(favorites) favorites")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(details?.data.about ?? "")
                                .font(.subheadline)
                                .lineLimit(7)
                                .truncationMode(.tail)
                            Button(isDescriptionExpanded ? "Show less" : "Show more") {
                                isDescriptionExpanded.toggle()
                            }
                            .font(.caption)
                            .sheet(isPresented: $isDescriptionExpanded) {
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        Text(details?.data.about ?? "")
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    .presentationDetents([.large, .medium])
                                    .presentationBackgroundInteraction(.automatic)
                                }
                                .scrollIndicators(.automatic)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: 110 * 1.5)
                .padding(.horizontal)
                Divider()
                if let voices = details?.data.voices, !voices.isEmpty {
                    VStack(alignment: .leading) {
                        LabelWithChevron(text: "Voice actors")
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(voices, id: \.person.malId) { voiceactor in
                                    NavigationLink(destination: VoiceActorDetailsView(
                                        id: voiceactor.person.malId,
                                        language: voiceactor.language,
                                        image: voiceactor.person.images.jpg.imageUrl,
                                        name: voiceactor.person.formattedName
                                    )) {
                                        VStack {
                                            AsyncImageView(imageUrl: voiceactor.person.images.jpg.imageUrl)
                                                .frame(width: 72, height: 108)
                                                .cornerRadius(12)
                                                .strokedBorder()
                                            
                                            Text(voiceactor.person.formattedName)
                                                .font(.caption)
                                                .frame(width: 72)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                            
                                            Text(voiceactor.language)
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.secondary)
                                                .frame(width: 72)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                Divider()
                if let animeAppearances = details?.data.animeAppearances, !animeAppearances.isEmpty {
                    VStack(alignment: .leading) {
                        LabelWithChevron(text: "Anime appearances")
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(animeAppearances, id: \.anime.malId) { result in
                                    VStack {
                                        AsyncImageView(imageUrl: result.anime.images.jpg.imageUrl)
                                            .frame(width: 72 * 1.25, height: 108 * 1.25)
                                            .cornerRadius(12 * 1.25)
                                            .strokedBorder()
                                        
                                        Text(result.anime.title ?? "")
                                            .font(.caption)
                                            .frame(width: 72 * 1.25, alignment: .leading)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Divider()
                if let mangaAppearances = details?.data.mangaAppearances, !mangaAppearances.isEmpty {
                    VStack(alignment: .leading) {
                        LabelWithChevron(text: "Manga appearances")
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(mangaAppearances, id: \.manga.malId) { result in
                                    VStack {
                                        AsyncImageView(imageUrl: result.manga.images.jpg.imageUrl)
                                            .frame(width: 72 * 1.25, height: 108 * 1.25)
                                            .cornerRadius(12)
                                            .strokedBorder()
                                        
                                        Text(result.manga.title ?? "")
                                            .font(.caption)
                                            .frame(width: 72 * 1.25, alignment: .leading)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .navigationTitle(character.metaData.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                details = try await jikanCharacterController.fetchCharacterDetails(id: character.metaData.malId)
            }
        }
    }
}
