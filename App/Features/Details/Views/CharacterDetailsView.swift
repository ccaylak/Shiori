import SwiftUI

struct CharacterDetailsView: View {
    
    let characterData: MetaData
    let role: String
    @State private var details: JikanCharacterFull? = nil
    @State private var isDescriptionExpanded = false
    
    @Environment(ToastManager.self)
    private var toastManager
    
    @Environment(AppSettings.self)
    private var settings
    
    let jikanCharacterController = JikanCharacterController()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 8) {
                    AsyncImageView(imageUrl: characterData.images.jpgImage.baseImage)
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
                                    
                                    Text("\(favorites) Favorites")
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
                        LabelWithChevron(
                            text: String(localized: "Voice Actors")
                        )
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(voices, id: \.person.malId) { voiceactor in
                                    NavigationLink(destination: VoiceActorDetailsView(
                                        id: voiceactor.person.malId,
                                        language: voiceactor.language,
                                        image: voiceactor.person.images.jpgImage.baseImage,
                                        name: voiceactor.person.preferredName(format: settings.nameFormat)
                                    )) {
                                        VStack {
                                            AsyncImageView(imageUrl: voiceactor.person.images.jpgImage.baseImage)
                                            .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                            .cornerRadius(12)
                                            .strokedBorder()
                                            
                                            Text(voiceactor.person.preferredName(format: settings.nameFormat))
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
                
                if let animeAppearances = details?.data.anime, !animeAppearances.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        LabelWithChevron(text: String(localized: "Anime Appearances"))
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(animeAppearances, id: \.anime?.malId) { result in
                                    NavigationLink(destination: DetailsView(media:
                                        MediaNode(
                                            id: result.anime?.malId ?? 0,
                                            title: result.anime?.title ?? "",
                                            mainPicture: Picture(
                                                large: result.anime?.images.jpgImage.largeImage ?? "", 
                                                medium: result.anime?.images.jpgImage.baseImage ?? ""
                                            ),
                                            mediaType: "tv")
                                       )) {
                                        VStack {
                                            AsyncImageView(imageUrl: result.anime?.images.jpgImage.baseImage ?? "")
                                            .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                            .cornerRadius(12)
                                            .strokedBorder()
                                            
                                            Text(result.anime?.title ?? "")
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
                
                if let mangaAppearances = details?.data.manga, !mangaAppearances.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        LabelWithChevron(text: String(localized: "Manga Appearances"))
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(mangaAppearances, id: \.manga?.malId) { result in
                                    NavigationLink(destination: DetailsView( media: MediaNode(
                                        id: result.manga?.malId ?? 0,
                                        title: result.manga?.title ?? "",
                                        mainPicture: Picture(
                                            large: result.manga?.images.jpgImage.largeImage ?? "",
                                            medium: result.manga?.images.jpgImage.baseImage ?? ""
                                        ),
                                        mediaType: "manga")
                                    )) {
                                        VStack {
                                            AsyncImageView(imageUrl: result.manga?.images.jpgImage.baseImage ?? "")
                                            .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                            .cornerRadius(12)
                                            .strokedBorder()

                                            Text(result.manga?.title ?? "")
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
        .scrollIndicators(.hidden)
        .noScrollEdgeEffect()
        .toolbar {
            if let url = URL(string: "https://myanimelist.net/character/\(characterData.malId)") {
                ToolbarItem {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(characterData.preferredName(format: settings.nameFormat))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                toastManager.isLoading = true
                defer { toastManager.isLoading = false }
                
                do {
                    details = try await jikanCharacterController.fetchCharacterDetails(id: characterData.malId, apiService: settings.extendedDataSource)
                } catch {
                    print("Failed to load character details:", error)
                }
            }
        }
    }
}
