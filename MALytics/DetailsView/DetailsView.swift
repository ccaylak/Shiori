import SwiftUI

struct DetailsView: View {
    
    @State var media: Media
    @State var isDescriptionExpanded = false
    @State private var isSheetPresented = false
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    
    @State private var mangaStatus = MangaProgressStatus.planToRead
    @State private var animeStatus = AnimeProgressStatus.planToWatch
    
    @State private var score: Int = 0
    @State private var progress: Int = 0
    @State private var endChapters: Int = 0
    
    @State private var showAlert = false
    
    let animeController = AnimeController()
    let mangaController = MangaController()
    let profileController = ProfileController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CoverAndDescriptionView(
                        title: media.title,
                        imageUrl: media.images.large,
                        score: media.score ?? 0.0,
                        mediaCount: media.numberOfChapters ?? 0,
                        description: media.description ?? "Unknown",
                        type: media.type ?? "Unknown",
                        mediaType: mediaType
                    )
                }
                Divider()
                Text("Your ratings").font(.subheadline)
                if (media.listStatus == nil) {
                    Text("Not rated yet")
                }
                if(media.listStatus != nil) {
                    HStack(alignment: .top) {
                        Text("Rating: \(media.listStatus?.rating ?? 0)")
                        Text("Status: \(media.listStatus?.status ?? "") ")
                        Text("Progress: \(media.listStatus?.readChapters ?? 0)")
                    }
                }
                Divider()
                GeneralInformationView(
                    type: media.type ?? "Unknown",
                    episodes: media.episodes ?? 0,
                    numberOfChapters: nil,
                    numberOfVolumes: nil,
                    startDate: media.startDate ?? "Unknown",
                    endDate: media.endDate ?? "",
                    studios: media.studios ?? [],
                    authorInfos: [],
                    status: media.status ?? "Unknown"
                )
                
                Divider()
                
                GenresView(genres: media.genres ?? [])
                
                Divider()
                
                StatisticsView(score: media.score ?? 0.0, rank: media.rank ?? 0, popularity: media.popularity ?? 0)
                Divider()
                
                if let relatedAnimes = media.relatedAnimes, !relatedAnimes.isEmpty && mediaType == .anime {
                    RelatedMediaView(relatedMediaItems: relatedAnimes)
                    Divider()
                }
                
                if let relatedMangas = media.relatedMangas, !relatedMangas.isEmpty && mediaType == .manga {
                    RelatedMediaView(relatedMediaItems: relatedMangas)
                    Divider()
                }
                
                if let recommendations = media.recommendations, !recommendations.isEmpty {
                    RecommendationsView(recommendations: recommendations)
                    Divider()
                }
                
                if let moreImages = media.moreImages, moreImages.count >= 3 {
                    MoreImagesView(images: moreImages)
                }
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .navigationTitle(media.title)
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSheetPresented = true
                }) {
                    Image(systemName: "star")
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(media.type ?? "")
                            .font(.subheadline)
                            .bold()
                        Text(media.title)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    HStack(alignment: .top) {
                        AsyncImageView(imageUrl: media.images.large)
                            .frame(maxHeight: 180)
                            .cornerRadius(12)

                        List {
                            if (mediaType == .manga){
                                Picker("Status", selection: $mangaStatus) {
                                    ForEach([MangaProgressStatus.completed, .reading, .dropped, .onHold, .planToRead], id: \.self) { mangaSelection in
                                        Text(mangaSelection.displayName).tag(mangaSelection)
                                    }
                                }
                            }
                            
                            if (mediaType == .anime){
                                Picker("Status", selection: $animeStatus) {
                                    ForEach([AnimeProgressStatus.completed, .watching, .dropped, .onHold, .planToWatch], id: \.self) { animeSelection in
                                        Text(animeSelection.displayName).tag(animeSelection)
                                    }
                                }
                            }

                            Picker((mediaType == .manga) ? "Chapters" : "Episodes", selection: $progress) {
                                let chapterRange = endChapters > 0 ? 0...endChapters : 0...1000
                                ForEach(chapterRange, id: \.self) { chapter in
                                    Text("\(chapter)").tag(chapter)
                                }
                            }

                            Picker("Rating", selection: $score) {
                                ForEach(0...10, id: \.self) { rating in
                                    if let ratingValue = RatingValues(rawValue: rating) {
                                        Text(ratingValue.displayName).tag(rating)
                                    } else {
                                        Text("Unknown")
                                    }
                                }
                            }

                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .scrollBounceBehavior(.basedOnSize)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)

                }
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Save") {
                            Task {
                                if (mediaType == .manga) {
                                    try await profileController.saveMangaProgress(mangaId: media.id, status: mangaStatus.rawValue, score: score, chapters: progress)
                                    media = try await mangaController.fetchMangaDetails(mangaId: media.id)
                                    isSheetPresented = false
                                }
                                if (mediaType == .anime) {
                                    try await profileController.saveAnimeProgress(animeId: media.id, status: animeStatus.rawValue, score: score, episodes: progress)
                                    media = try await animeController.fetchAnimeDetails(animeId: media.id)
                                    isSheetPresented = false
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Edit")
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            showAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                                        .symbolRenderingMode(.palette)
                                        .foregroundColor(.red)
                        }
                        .alert("Delete library entry", isPresented: $showAlert) {
                            Button("Delete", role: .destructive) {
                                Task {
                                    if(mediaType == .manga) {
                                        try await profileController.deleteMangaListItem(mangaId: media.id)
                                        media = try await mangaController.fetchMangaDetails(mangaId: media.id)
                                    }
                                    if(mediaType == .anime) {
                                        try await profileController.deleteAnimeListItem(animeId: media.id)
                                        media = try await animeController.fetchAnimeDetails(animeId: media.id)
                                         }
                                    showAlert = false
                                    isSheetPresented = false
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Are you sure you want to delete \(media.title) from your library?")
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .presentationDetents([.fraction(0.5)])
                .presentationBackgroundInteraction(.disabled)
                .presentationBackground(.regularMaterial)
            }
        }
        .onAppear {
            Task {
                if (mediaType == .anime){
                    media = try await animeController.fetchAnimeDetails(animeId: media.id)
                }
                
                if(mediaType == .manga) {
                    media = try await mangaController.fetchMangaDetails(mangaId: media.id)
                }
            }
        }
    }
}


#Preview {
    DetailsView(
        media: Media(
            id: 1,
            title: "Tokyo Ghoul",
            images: Images(
                medium: "https://cdn.myanimelist.net/images/anime/9/74398.jpg",
                large: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg"
            ),
            startDate: "2020-01-01",
            type: "manga",
            status: "on_hiatus",
            episodes: 10,
            numberOfVolumes: 10,
            numberOfChapters: 20,
            authors: [
                AuthorInfos(
                    author: AuthorInfos.Author(
                        id: 1,
                        firstName: "Sui",
                        lastName: "Ishida"
                    ),
                    role: "Writer"
                )
            ]
        )
    )
}
