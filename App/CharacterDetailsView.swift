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
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 8) {
                    AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                        .frame(width: CoverSize.extraLarge.size.width, height: CoverSize.extraLarge.size.height)
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
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(Color.red)
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
                                .lineLimit(12)
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
                .frame(maxHeight: CoverSize.extraLarge.size.height)
                .padding(.horizontal)
                
                if let voices = details?.data.voices, !voices.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        LabelWithChevron(text: String(localized: "Voice actors"))
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
                                                .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                                .cornerRadius(12)
                                                .strokedBorder()
                                            
                                            Text(voiceactor.person.formattedName)
                                                .font(.caption)
                                                .frame(maxWidth: CoverSize.medium.size.width)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                            
                                            Text(VoiceActorLanguage(rawValue: voiceactor.language)?.displayName ?? VoiceActorLanguage.unknown.displayName)
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.secondary)
                                                .frame(maxWidth: CoverSize.medium.size.width)
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
                
                if let animeAppearances = details?.data.animeAppearances, !animeAppearances.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        LabelWithChevron(text: String(localized: "Anime appearances"))
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(animeAppearances, id: \.anime.malId) { result in
                                    NavigationLink(destination: DetailsView(media: Media(
                                        id: result.anime.malId,
                                        title: result.anime.title ?? "-",
                                        images: Images(large: result.anime.images.jpg.imageUrl),
                                        type: "tv"
                                    ))) {
                                        VStack {
                                            AsyncImageView(imageUrl: result.anime.images.jpg.imageUrl)
                                                .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                                .cornerRadius(12)
                                                .strokedBorder()
                                            
                                            Text(result.anime.title ?? "")
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
                    }
                }
                
                if let mangaAppearances = details?.data.mangaAppearances, !mangaAppearances.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        LabelWithChevron(text: String(localized: "Manga appearances"))
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(mangaAppearances, id: \.manga.malId) { result in
                                    NavigationLink(destination: DetailsView(media: Media(
                                        id: result.manga.malId,
                                        title: result.manga.title ?? "-",
                                        images: Images(large: result.manga.images.jpg.imageUrl),
                                        type: "manga"
                                    ))){
                                        VStack {
                                            AsyncImageView(imageUrl: result.manga.images.jpg.imageUrl)
                                                .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                                .cornerRadius(12)
                                                .strokedBorder()
                                            
                                            Text(result.manga.title ?? "")
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
                            .padding(.bottom)
                        }
                    }
                }
            }
        }
        .noScrollEdgeEffect()
        .toolbar {
            ToolbarItem {
                ShareLink(item: URL(string: details?.data.url ?? "myanimelist.net")!) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.accentColor)
                }
                .disabled(details?.data.url == nil)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(character.metaData.formattedName)
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
