import SwiftUI

struct DetailsView: View {
    
    @State var media: Media
    @State var isDescriptionExpanded = false
    @State private var isSheetPresented = false
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    @AppStorage("accentColor") private var accentColor = AccentColor.blue
    
    @State private var mangaStatus = MangaProgressStatus.planToRead
    @State private var animeStatus = AnimeProgressStatus.planToWatch
    
    @State private var rating: Int = 0
    @State private var progress: Int = 0
    @State private var end: Int = 0
    
    @State private var showAlert = false
    @State private var isLoading = false

    @StateObject private var tokenHandler: TokenHandler = .shared
    
    let animeController = AnimeController()
    let mangaController = MangaController()
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        CoverAndDescriptionView(
                            title: media.title,
                            imageUrl: media.images.large,
                            score: media.getScore,
                            mediaCount: media.getChapters,
                            description: media.getDescription,
                            type: media.getType,
                            mediaType: mediaType
                        )
                    }
                    Group {
                        if tokenHandler.isAuthenticated {
                            VStack(alignment: .center, spacing: 15) {
                                Text("Your statistics")
                                    .font(.subheadline)
                                    .bold()
                                
                                HStack(alignment: .center) {
                                    if !media.getListStatus.getStatus.isEmpty {
                                        VStack {
                                            Text("Rating")
                                                .font(.caption)
                                                .bold()
                                            Label("\(media.getListStatus.getRating)", systemImage: "star.fill")
                                                .accentColor(.primary)
                                        }
                                        Spacer()
                                        VStack {
                                            Text("Status")
                                                .font(.caption)
                                                .bold()
                                            Label(media.getListStatus.getStatus, systemImage: progressIcon(status: media.getListStatus.getStatus))
                                                .accentColor(.primary)
                                        }
                                        Spacer()
                                        VStack {
                                            Text(mediaType == .anime ? "Episodes" : "Chapters")
                                                .font(.caption)
                                                .bold()
                                            Label(mediaType == .anime
                                                  ? "\(media.getListStatus.getWatchedEpisodes)/\(media.getEpisodes)"
                                                  : "\(media.getListStatus.getReadChapters)/\(media.getChapters)", systemImage: mediaType == .anime ? "tv.fill" : "book.pages")
                                            .accentColor(.primary)
                                        }
                                    } else {
                                        Button("Add to \(mediaType == .anime ? "Watch" : "Reading") list") {
                                            Task {
                                                isLoading = true
                                                defer { isLoading = false }
                                                if (mediaType == .anime) {
                                                    try await animeController.addToWatchList(id: media.id)
                                                    media = try await animeController.fetchDetails(id: media.id)
                                                }
                                                if (mediaType == .manga) {
                                                    try await mangaController.addToReadingList(id: media.id)
                                                    media = try await mangaController.fetchDetails(id: media.id)
                                                }
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                            }
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
                            .background(Color.getByColorString(accentColor.rawValue).opacity(0.3))
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            GroupBox {
                                Text("Log in with your MyAnimeList account to see your \(mediaType.rawValue) progress, rating, and status.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            } label: {
                                Label("Info", systemImage: "info.circle")
                                    .font(.headline)
                            }
                        }
                    }
                    
                    Divider()
                    
                    GeneralInformationView(
                        type: media.getType,
                        episodes: media.getEpisodes,
                        numberOfChapters: media.getChapters,
                        numberOfVolumes: media.getVolumes,
                        startDate: media.getStartDate,
                        endDate: media.getEndDate,
                        studios: media.getStudios,
                        authorInfos: media.getAuthors,
                        status: media.getStatus
                    )
                    
                    Divider()
                    
                    GenresView(genres: media.getGenres)
                    
                    Divider()
                    
                    StatisticsView(
                        score: media.getScore,
                        rank: media.getRank,
                        popularity: media.getPopularity,
                        users: media.getUsers
                    )
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
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .navigationTitle(media.title)
                .padding(.horizontal)
                .toolbar {
                    if (!media.getListStatus.getStatus.isEmpty) {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isSheetPresented = true
                            }) {
                                Text("Edit")
                            }
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        let escapedTitle = media.title.replacingOccurrences(of: " ", with: "_")
                        
                        if let url = URL(string: "https://myanimelist.net/\(mediaType.rawValue)/\(media.id)/\(escapedTitle)") {
                            ShareLink(item: url) {
                                Label("Share \(mediaType.rawValue.capitalized)", systemImage: "square.and.arrow.up")
                            }
                        } else {
                            Text("Invalid URL")
                        }
                    }
                }
                .sheet(isPresented: $isSheetPresented) {
                                    if (tokenHandler.isAuthenticated) {
                                        NavigationStack {
                                            List {
                                                if (mediaType == .manga) {
                                                    Picker("Status", selection: $mangaStatus) {
                                                        ForEach(MangaProgressStatus.allCases, id: \.self) { mangaSelection in
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
                                                    let chapterRange = end > 0 ? 0...end : 0...1000
                                                    ForEach(chapterRange, id: \.self) { chapter in
                                                        Text("\(chapter)").tag(chapter)
                                                    }
                                                }
                                                
                                                Picker("Rating", selection: $rating) {
                                                    ForEach(0...10, id: \.self) { rating in
                                                        if let ratingValue = RatingValues(rawValue: rating) {
                                                            Text(ratingValue.displayName).tag(rating)
                                                        } else {
                                                            Text("Unknown")
                                                        }
                                                    }
                                                }
                                                
                                            }
                                            .scrollContentBackground(.hidden)
                                            .scrollBounceBehavior(.basedOnSize)
                                            .toolbar {
                                                ToolbarItem(placement: .primaryAction) {
                                                    Button("Save") {
                                                        Task {
                                                            if (mediaType == .manga) {
                                                                try await mangaController.saveProgress(id: media.id, status: mangaStatus.rawValue, score: rating, chapters: progress)
                                                                media = try await mangaController.fetchDetails(id: media.id)
                                                                isSheetPresented = false
                                                            }
                                                            if (mediaType == .anime) {
                                                                try await animeController.saveProgress(id: media.id, status: animeStatus.rawValue, score: rating, episodes: progress)
                                                                media = try await animeController.fetchDetails(id: media.id)
                                                                isSheetPresented = false
                                                            }
                                                        }
                                                    }
                                                }
                                                ToolbarItem(placement: .principal) {
                                                    Text(mediaType == .manga ? "Edit Reading Progress" : "Edit Watch Progress")
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
                                                                    try await mangaController.deleteEntry(id: media.id)
                                                                    media = try await mangaController.fetchDetails(id: media.id)
                                                                }
                                                                if(mediaType == .anime) {
                                                                    try await animeController.deleteEntry(id: media.id)
                                                                    media = try await animeController.fetchDetails(id: media.id)
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
                                            .presentationDetents([.fraction(0.4)])
                                            .presentationBackgroundInteraction(.disabled)
                                            .presentationBackground(.regularMaterial)
                                        }
                                    }
                                    else {
                                        GroupBox {
                                            Text("Log in with your MyAnimeList account to be able to edit \(media.title)'s progress, rating and progress status.")
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.leading)
                                        } label: {
                                            Label("Info", systemImage: "info.circle")
                                                .font(.headline)
                                        }
                                        .navigationBarTitleDisplayMode(.inline)
                                        .presentationDetents([.fraction(0.2)])
                                        .presentationBackgroundInteraction(.disabled)
                                        .presentationBackground(.regularMaterial)
                                    }
                                }
            }
            
            if isLoading {
                GroupBox {
                    VStack {
                        ProgressView()
                        Text("Loading...")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(10)
            }
        }
        .onAppear {
            Task {
                isLoading = true
                defer { isLoading = false }
                do {
                    if mediaType == .anime {
                        media = try await animeController.fetchDetails(id: media.id)
                        if let validStatus = AnimeProgressStatus(rawValue: media.getListStatus.getStatus) {
                            animeStatus = validStatus
                        }
                        progress = media.getListStatus.getWatchedEpisodes
                        rating = media.getListStatus.getRating
                        end = media.getEpisodes
                    }
                    
                    if mediaType == .manga {
                        media = try await mangaController.fetchDetails(id: media.id)
                        if let validStatus = MangaProgressStatus(rawValue: media.getListStatus.getStatus) {
                            mangaStatus = validStatus
                        }
                        progress = media.getListStatus.getReadChapters
                        rating = media.getListStatus.getRating
                        end = media.getChapters
                    }
                } catch {
                    print("Fehler beim Abrufen der Daten: \(error)")
                }
            }
        }
    }
    
    private func progressIcon(status: String) -> String {
        switch status {
        case "completed": return "checkmark"
        case "watching": return "play.fill"
        case "reading": return "book.fill"
        case "on_hold": return "pause.fill"
        case "plan_to_watch", "plan_to_read": return "calendar"
        case "dropped": return "trash.fill"
        default: return "questionmark"
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
            ],
            users: 10
        )
    )
}
