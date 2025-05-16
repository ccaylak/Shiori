import SwiftUI

struct DetailsView: View {
    
    @State var media: Media
    @State var isDescriptionExpanded = false
    @State private var isSheetPresented = false
    
    @State private var jikanCharacters: JikanCharacter = JikanCharacter(data: [])
    
    struct UserProgress {
        var mangaProgress: ProgressStatus.Manga
        var animeProgress: ProgressStatus.Anime
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
    
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @ObservedObject private var resultManager: ResultManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    let animeController = AnimeController()
    let mangaController = MangaController()
    let jikanCharacterController = JikanCharacterController()
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        CoverSummaryView(
                            title: media.getTitle,
                            imageUrl: media.getCover,
                            score: media.getScore,
                            chapters: media.getChapters,
                            volumes: media.getVolumes,
                            episodes: media.getEpisodes,
                            summary: media.getSummary,
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
                                                alertManager.isLoading = true
                                                alertManager.showAddedAlert = true
                                                defer {
                                                    alertManager.isLoading = false
                                                }
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
                            .onTapGesture(perform: {
                                if media.getListStatus.getProgressStatus != .unknown {
                                    isSheetPresented = true
                                }
                            })
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
                    Sections(media: media, jikanCharacters: jikanCharacters)
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
                            Menu {
                                ShareLink(item: url) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                
                                NavigationLink {
                                    EditDetailsView()
                                } label: {
                                    Label("Edit layout", systemImage: "slider.horizontal.3")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
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
                                        ForEach([ProgressStatus.Manga.completed, .reading, .dropped, .onHold, .planToRead], id: \.self) { mangaSelection in
                                            Text(mangaSelection.displayName).tag(mangaSelection)
                                        }
                                    }
                                }
                                
                                if (resultManager.mediaType == .anime){
                                    Picker("Status", selection: $userProgress.animeProgress) {
                                        ForEach([ProgressStatus.Anime.completed, .watching, .dropped, .onHold, .planToWatch], id: \.self) { animeSelection in
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
                                                alertManager.showUpdatedAlert = true
                                                media = try await mangaController.fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                            if (resultManager.mediaType == .anime) {
                                                try await animeController.saveProgress(id: media.id, status: userProgress.animeProgress.rawValue, score: userProgress.rating, episodes: userProgress.progress)
                                                alertManager.showUpdatedAlert = true
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
                                                    alertManager.showRemovedAlert = true
                                                    media = try await mangaController.fetchDetails(id: media.id)
                                                }
                                                if(resultManager.mediaType == .anime) {
                                                    try await animeController.deleteEntry(id: media.id)
                                                    alertManager.showRemovedAlert = true
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
        }
        .onAppear {
            Task {
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                do {
                    if resultManager.mediaType == .anime {
                        media = try await animeController.fetchDetails(id: media.id)
                        jikanCharacters = try await jikanCharacterController.fetchAnimeCharacter(id: media.id)
                        
                        userProgress.progress = media.getListStatus.getWatchedEpisodes
                        userProgress.rating = media.getListStatus.getRating
                        userProgress.end = media.getEpisodes
                    }
                    
                    if resultManager.mediaType == .manga {
                        media = try await mangaController.fetchDetails(id: media.id)
                        jikanCharacters = try await jikanCharacterController.fetchMangaCharacter(id: media.id)

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

private struct Sections: View {
    let media: Media
    let jikanCharacters: JikanCharacter
    @ObservedObject private var sectionsManager: SectionsManager = .shared
    
    private var activeSections: [EditSections] {
        EditSections.allCases.filter { type in
            switch type {
            case .general:
                return sectionsManager.showGeneral
            case .genres:
                return sectionsManager.showGenres
            case .score:
                return sectionsManager.showScore
            case .related:
                return sectionsManager.showRelated
            case .recommendations:
                return sectionsManager.showRecommendations
            case .characters:
                return sectionsManager.showCharacters
            }
        }
    }
    
    var body: some View {
        ForEach(Array(activeSections.enumerated()), id: \.element) { index, type in
            if index > 0 {
                Divider()
            }
            sectionView(for: type)
        }
    }
    
    @ViewBuilder
    private func sectionView(for type: EditSections) -> some View {
        switch type {
        case .general:
            GeneralOverviewView(
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
        case .genres:
            GenresView(genres: media.getGenres)
        case .score:
            StatisticsView(
                score: media.getScore,
                rank: media.getRank,
                popularity: media.getPopularity,
                users: media.getUsers
            )
        case .related:
            RelatedMediaView(media: media, mediaType: media.getMediaType)
        case .recommendations:
            RecommendationsView(recommendations: media.getRecommendations)
        case .characters:
            CharactersView(characters: jikanCharacters.data)
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
    .environmentObject(AlertManager.shared)
}
