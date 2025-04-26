import SwiftUI

struct DetailsView: View {
    
    @State var media: Media
    @State var isDescriptionExpanded = false
    @State private var isSheetPresented = false
    
    struct UserProgress {
        var mangaProgress: MangaProgressStatus
        var animeProgress: AnimeProgressStatus
        var rating: Int
        var progress: Int
        var end: Int
    }

    @State private var userProgress = UserProgress(
        mangaProgress: .planToRead,
        animeProgress: .planToWatch,
        rating: 0,
        progress: 0,
        end: 0
    )
    
    @State private var showAlert = false
    @State private var isLoading = false
    
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @ObservedObject private var resultManager: ResultManager = .shared
    
    let animeController = AnimeController()
    let mangaController = MangaController()
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        CoverAndDescriptionView(
                            title: media.getTitle,
                            imageUrl: media.getCover,
                            score: media.getScore,
                            mediaCount: media.getChapters,
                            description: media.getDescription,
                            type: media.getType
                        )
                         
                    }
                    
                    Group {
                        if tokenHandler.isAuthenticated {
                            VStack(alignment: .center, spacing: 15) {
                                Text("Your statistics")
                                    .font(.caption)
                                    .bold()
                                
                                HStack(alignment: .center) {
                                    if media.getListStatus.getProgressStatus != .unknown {
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
                                            Text(media.getListStatus.getProgressStatus.displayName)
                                              .accentColor(.primary)
                                        }
                                        Spacer()
                                        VStack {
                                            Text(resultManager.mediaType == .anime ? "Episodes" : "Chapters")
                                                .font(.caption)
                                                .bold()
                                            Label(
                                                resultManager.mediaType == .anime
                                                        ? "\(media.getListStatus.getWatchedEpisodes)/\((media.getEpisodes != 0) ? "\(media.getEpisodes)" : "?")"
                                                        : "\(media.getListStatus.getReadChapters)/\((media.getChapters != 0) ? "\(media.getChapters)" : "?")",
                                                    systemImage: resultManager.mediaType == .anime ? "tv.fill" : "book.pages"
                                            )
                                            .accentColor(.primary)
                                        }
                                    } else {
                                        Button("Add to Library") {
                                            Task {
                                                isLoading = true
                                                defer { isLoading = false }
                                                if (resultManager.mediaType == .anime) {
                                                    try await animeController.addToWatchList(id: media.id)
                                                    media = try await animeController.fetchDetails(id: media.id)
                                                }
                                                if (resultManager.mediaType == .manga) {
                                                    try await mangaController.addToReadingList(id: media.id)
                                                    media = try await mangaController.fetchDetails(id: media.id)
                                                }
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
                            .background(Color.getByColorString(settingsManager.accentColor.rawValue).opacity(0.3))
                            .cornerRadius(12)
                            .onTapGesture(perform: {isSheetPresented = true})
                            
                        } else {
                            GroupBox {
                                Text("Log in with your MyAnimeList account to see your \(resultManager.mediaType.displayName) progress, rating, and status.")
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
                        status: media.getMediaStatus
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
                    
                    if let relatedAnimes = media.relatedAnimes, !relatedAnimes.isEmpty && resultManager.mediaType == .anime {
                        RelatedMediaView(relatedMediaItems: relatedAnimes)
                        Divider()
                    }
                    
                    if let relatedMangas = media.relatedMangas, !relatedMangas.isEmpty && resultManager.mediaType == .manga {
                        RelatedMediaView(relatedMediaItems: relatedMangas)
                        Divider()
                    }
                    
                    if let recommendations = media.recommendations, !recommendations.isEmpty {
                        RecommendationsView(recommendations: recommendations)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .navigationTitle(media.getTitle)
                .padding(.horizontal)
                .toolbar {
                    if media.getListStatus.getProgressStatus != .unknown {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isSheetPresented = true
                            }) {
                                Text("Edit")
                            }
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        let escapedTitle = media.getTitle.replacingOccurrences(of: " ", with: "_")
                        
                        if let url = URL(string: "https://myanimelist.net/\(resultManager.mediaType.rawValue)/\(media.id)/\(escapedTitle)") {
                            ShareLink(item: url) {
                                Image(systemName: "square.and.arrow.up")
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
                                if (resultManager.mediaType == .manga) {
                                    Picker("Status", selection: $userProgress.mangaProgress) {
                                        ForEach([MangaProgressStatus.completed, .reading, .dropped, .onHold, .planToRead], id: \.self) { mangaSelection in
                                            Text(mangaSelection.displayName).tag(mangaSelection)
                                        }
                                    }
                                }
                                
                                if (resultManager.mediaType == .anime){
                                    Picker("Status", selection: $userProgress.animeProgress) {
                                        ForEach([AnimeProgressStatus.completed, .watching, .dropped, .onHold, .planToWatch], id: \.self) { animeSelection in
                                            Text(animeSelection.displayName).tag(animeSelection)
                                        }
                                    }
                                }
                                
                                Picker((resultManager.mediaType == .manga) ? "Chapters" : "Episodes", selection: $userProgress.progress) {
                                    let chapterRange = userProgress.end > 0 ? 0...userProgress.end : 0...1000
                                    ForEach(chapterRange, id: \.self) { chapter in
                                        Text("\(chapter)").tag(chapter)
                                    }
                                }
                                
                                Picker("Rating", selection: $userProgress.rating) {
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
                                            if (resultManager.mediaType == .manga) {
                                                try await mangaController.saveProgress(id: media.id, status: userProgress.mangaProgress.rawValue, score: userProgress.rating, chapters: userProgress.progress)
                                                media = try await mangaController.fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                            if (resultManager.mediaType == .anime) {
                                                try await animeController.saveProgress(id: media.id, status: userProgress.animeProgress.rawValue, score: userProgress.rating, episodes: userProgress.progress)
                                                media = try await animeController.fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                        }
                                    }
                                }
                                ToolbarItem(placement: .principal) {
                                    Text(resultManager.mediaType == .manga ? "Edit Reading Progress" : "Edit Watch Progress")
                                }
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(action: {
                                        showAlert = true
                                    }) {
                                        Image(systemName: "trash")
                                            .symbolRenderingMode(.palette)
                                            .foregroundColor(.red)
                                    }
                                    .alert("Delete progress", isPresented: $showAlert) {
                                        Button("Delete", role: .destructive) {
                                            Task {
                                                if(resultManager.mediaType == .manga) {
                                                    try await mangaController.deleteEntry(id: media.id)
                                                    media = try await mangaController.fetchDetails(id: media.id)
                                                }
                                                if(resultManager.mediaType == .anime) {
                                                    try await animeController.deleteEntry(id: media.id)
                                                    media = try await animeController.fetchDetails(id: media.id)
                                                }
                                                showAlert = false
                                                isSheetPresented = false
                                            }
                                        }
                                        Button("Cancel", role: .cancel) {}
                                    } message: {
                                        Text("Do you really want to delete your progress for \(media.getTitle)?")
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
                            Text("Log in with your MyAnimeList account to be able to edit \(media.getTitle)'s progress, rating and progress status.")
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
                    if resultManager.mediaType == .anime {
                        media = try await animeController.fetchDetails(id: media.id)
                        
                        userProgress.progress = media.getListStatus.getWatchedEpisodes
                        userProgress.rating = media.getListStatus.getRating
                        userProgress.end = media.getEpisodes
                    }
                    
                    if resultManager.mediaType == .manga {
                        media = try await mangaController.fetchDetails(id: media.id)
                        
                        userProgress.progress = media.getListStatus.getReadChapters
                        userProgress.rating = media.getListStatus.getRating
                        userProgress.end = media.getChapters
                    }
                    
                    let wrapper = media.getListStatus.getProgressStatus

                    switch wrapper {
                    case .manga(let mProgress):
                        userProgress.mangaProgress = mProgress
                    case .anime(let aProgress):
                        userProgress.animeProgress = aProgress
                    case .unknown:
                        userProgress.mangaProgress = .reading // oder was immer sinnvoll ist
                    }
                } catch {
                    print("Fehler beim Abrufen der Daten: \(error)")
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
            ],
            users: 10
        )
    )
}
