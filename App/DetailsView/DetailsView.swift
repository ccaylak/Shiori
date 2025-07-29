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
        var comments: String
        var volumes: Int
        var currentVolume: Int
        var startDate: Date?
        var endDate: Date?
    }
    
    @State private var userProgress = UserProgress(
        mangaProgress: .planToRead,
        animeProgress: .planToWatch,
        rating: 0,
        progress: 0,
        end: 0,
        comments: "",
        volumes: 0,
        currentVolume: 0,
        startDate: nil,
        endDate: nil
    )
    
    @State private var showAlert = false
    
    @State private var showComments = false
    @State private var showStartDate = false
    @State private var showFinishDate = false
    
    @State private var didTap = false
    
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @ObservedObject private var resultManager: ResultManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    let animeController = AnimeController()
    let mangaController = MangaController()
    let jikanCharacterController = JikanCharacterController()
    
    var body: some View {
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
                    
                    if tokenHandler.isAuthenticated {
                        if media.getListStatus.getProgressStatus != .unknown {
                            HStack(alignment: .center) {
                                VStack(spacing: 3) {
                                    Image(systemName: "star.fill")
                                        .font(.subheadline)
                                    
                                    Text("Rating")
                                        .font(.caption)
                                    
                                    Text("\(media.getListStatus.getRating)")
                                        .font(.body)
                                        .accentColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                Divider()
                                VStack(spacing: 3) {
                                    media.getListStatus.getProgressStatus.libraryIcon
                                    
                                    Text("Status")
                                        .font(.caption)
                                    
                                    Text(media.getListStatus.getProgressStatus.displayName)
                                        .font(.callout)
                                        .accentColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                if (resultManager.mediaType == .anime && media.getListStatus.getWatchedEpisodes != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "tv.fill")
                                            .font(.subheadline)
                                        
                                        Text("Episode")
                                            .font(.caption)
                                        
                                        Text("\(media.getListStatus.getWatchedEpisodes)\(media.getEpisodes != 0 ? "/\(media.getEpisodes)" : "")")
                                            .font(.body)
                                            .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                if (resultManager.mediaType == .manga && media.getListStatus.getReadVolumes != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "character.book.closed.fill.ja")
                                            .font(.subheadline)
                                        
                                        Text("Volume")
                                            .font(.caption)
                                        
                                        Text("\(media.getListStatus.getReadVolumes)\(media.getVolumes != 0 ? "/\(media.getVolumes)" : "")")
                                            .font(.body)
                                            .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                if (resultManager.mediaType == .manga && media.getListStatus.getReadChapters != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "book.pages.fill")
                                            .font(.subheadline)
                                        
                                        Text("Chapter")
                                            .font(.caption)
                                        
                                        Text("\(media.getListStatus.getReadChapters)\(media.getChapters != 0 ? "/\(media.getChapters)" : "")")
                                            .font(.body)
                                            .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding([.top, .bottom], 8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .onTapGesture(perform: {
                                if media.getListStatus.getProgressStatus != .unknown {
                                    isSheetPresented = true
                                }
                            })
                        } else {
                            Button {
                                didTap.toggle()
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
                            } label : {
                                Label("Add to library", systemImage: "plus.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .font(.title3)
                                    .padding(.vertical, 4)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .buttonStyle(.borderedProminent)
                            .sensoryFeedback(.success, trigger: didTap)
                        }
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
                        .padding(.horizontal)
                        .backgroundStyle(Color(.secondarySystemGroupedBackground))
                    }
                    Sections(media: media, jikanCharacters: jikanCharacters)
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
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
                                Section {
                                    Picker("Progress", selection: $userProgress.mangaProgress) {
                                        ForEach([ProgressStatus.Manga.completed, .reading, .dropped, .onHold, .planToRead], id: \.self) { mangaSelection in
                                            Text(mangaSelection.displayName).tag(mangaSelection)
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
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Mode")
                                        
                                        Picker("Mode", selection: $settingsManager.mangaMode) {
                                            ForEach(MangaMode.allCases, id: \.self) { mode in
                                                Text(mode.displayName).tag(mode)
                                            }
                                        }
                                        .pickerStyle(.segmented)
                                    }
                                    
                                    if (settingsManager.mangaMode == MangaMode.all) {
                                        if userProgress.end != 0 {
                                            Picker(selection: $userProgress.progress, label:
                                                    VStack(alignment: .leading, spacing: 4) {
                                                Text("Chapter")
                                                Text("\(userProgress.progress)/\(userProgress.end)")
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                            }
                                            ) {
                                                ForEach(0...userProgress.end, id: \.self) { chapter in
                                                    Text("\(chapter)").tag(chapter)
                                                }
                                            }
                                        } else {
                                            Stepper(value: $userProgress.progress, in: 0...Int.max) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Chapter")
                                                    
                                                    Text("\(userProgress.progress)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                    
                                                }
                                            }
                                        }
                                        
                                        if userProgress.volumes != 0 {
                                            Picker(selection: $userProgress.currentVolume, label:
                                                    VStack(alignment: .leading, spacing: 4) {
                                                Text("Volume")
                                                Text("\(userProgress.currentVolume)/\(userProgress.volumes)")
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                            }
                                            ) {
                                                ForEach(0...userProgress.volumes, id: \.self) { volume in
                                                    Text("\(volume)").tag(volume)
                                                }
                                            }
                                        } else {
                                            Stepper(value: $userProgress.currentVolume, in: 0...Int.max) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Volume")
                                                    
                                                    Text("\(userProgress.currentVolume)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if (settingsManager.mangaMode == MangaMode.chapter) {
                                        if userProgress.end != 0 {
                                            Picker(selection: $userProgress.progress, label:
                                                    VStack(alignment: .leading, spacing: 4) {
                                                Text("Chapter")
                                                Text("\(userProgress.progress)/\(userProgress.end)")
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                            }
                                            ) {
                                                ForEach(0...userProgress.end, id: \.self) { chapter in
                                                    Text("\(chapter)").tag(chapter)
                                                }
                                            }
                                        } else {
                                            Stepper(value: $userProgress.progress, in: 0...Int.max) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Chapter")
                                                    
                                                    Text("\(userProgress.progress)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                    
                                                }
                                            }
                                        }
                                    }
                                    if (settingsManager.mangaMode == MangaMode.volume) {
                                        if userProgress.volumes != 0 {
                                            Picker(selection: $userProgress.currentVolume, label:
                                                    VStack(alignment: .leading, spacing: 4) {
                                                Text("Volume")
                                                Text("\(userProgress.currentVolume)/\(userProgress.volumes)")
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                            }
                                            ) {
                                                ForEach(0...userProgress.volumes, id: \.self) { volume in
                                                    Text("\(volume)").tag(volume)
                                                }
                                            }
                                        } else {
                                            Stepper(value: $userProgress.currentVolume, in: 0...Int.max) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Volume")
                                                    
                                                    Text("\(userProgress.currentVolume)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if (resultManager.mediaType == .anime){
                                Picker("Status", selection: $userProgress.animeProgress) {
                                    ForEach([ProgressStatus.Anime.completed, .watching, .dropped, .onHold, .planToWatch], id: \.self) { animeSelection in
                                        Text(animeSelection.displayName).tag(animeSelection)
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
                                
                                if userProgress.end != 0 {
                                    HStack {
                                        Text("Episode")
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                        Menu {
                                            ForEach(0...userProgress.end, id: \.self) { episode in
                                                Button("\(episode)") {
                                                    userProgress.progress = episode
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 4) {
                                                Text("\(userProgress.progress)/\(userProgress.end)")
                                                    .foregroundColor(.secondary)
                                                Image(systemName: "chevron.up.chevron.down")
                                                    .imageScale(.small)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                } else {
                                    Stepper("Episode \(userProgress.progress)", value: $userProgress.progress, in: 0...Int.max)
                                }
                            }
                            
                            Section {
                                Button(action: {
                                    withAnimation {
                                        showComments.toggle()
                                        if !showComments {
                                            userProgress.comments = ""
                                        }
                                    }
                                }
                                ){
                                    Label {
                                        Text(showComments ? "Remove comments" : "Add comments")
                                    } icon: {
                                        Image(systemName: showComments ? "minus.circle.fill" : "plus.circle.fill")
                                            .symbolRenderingMode(.monochrome)
                                            .foregroundStyle(showComments ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if showComments {
                                    TextField("Comments", text: $userProgress.comments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            
                            Section {
                                Button(action: {
                                    withAnimation {
                                        showStartDate.toggle()
                                        if !showStartDate {
                                            userProgress.startDate = nil
                                        }
                                    }
                                }) {
                                    Label {
                                        Text(showStartDate ? "Remove start date" : "Add start date")
                                    } icon: {
                                        Image(systemName: showStartDate ? "calendar.badge.minus" : "calendar.badge.plus")
                                            .foregroundStyle(showStartDate ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if showStartDate {
                                    DatePicker(
                                        "Start date",
                                        selection: Binding(
                                            get: { userProgress.startDate ?? Date() },
                                            set: { userProgress.startDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        showFinishDate.toggle()
                                        if !showFinishDate {
                                            userProgress.endDate = nil
                                        }
                                    }
                                }) {
                                    Label {
                                        Text(showFinishDate ? "Remove finish date" : "Add finish date")
                                    } icon: {
                                        Image(systemName: showFinishDate ? "calendar.badge.minus" : "calendar.badge.plus")
                                            .foregroundStyle(showFinishDate ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if showFinishDate {
                                    DatePicker(
                                        "Finish date",
                                        selection: Binding(
                                            get: { userProgress.endDate ?? Date() },
                                            set: { userProgress.endDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .padding(.horizontal)
                        .scrollContentBackground(.hidden)
                        .scrollBounceBehavior(.basedOnSize)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("Save") {
                                    Task {
                                        if (resultManager.mediaType == .manga) {
                                            try await mangaController.saveProgress(
                                                id: media.id,
                                                status: userProgress.mangaProgress.rawValue,
                                                score: userProgress.rating,
                                                chapters: userProgress.progress,
                                                volumes: userProgress.currentVolume,
                                                comments: userProgress.comments,
                                                startDate: userProgress.startDate,
                                                finishDate: userProgress.endDate
                                            )
                                            alertManager.showUpdatedAlert = true
                                            media = try await mangaController.fetchDetails(id: media.id)
                                            isSheetPresented = false
                                        }
                                        if (resultManager.mediaType == .anime) {
                                            try await animeController.saveProgress(
                                                id: media.id,
                                                status: userProgress.animeProgress.rawValue,
                                                score: userProgress.rating,
                                                episodes: userProgress.progress,
                                                comments: userProgress.comments,
                                                startDate: userProgress.startDate,
                                                finishDate: userProgress.endDate
                                            )
                                            alertManager.showUpdatedAlert = true
                                            media = try await animeController.fetchDetails(id: media.id)
                                            isSheetPresented = false
                                        }
                                    }
                                }
                                .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
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
                                        didTap.toggle()
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
                                }.sensoryFeedback(.warning, trigger: didTap)
                            }
                        }
                        .navigationTitle(resultManager.mediaType == .manga ? "Edit Reading Progress" : "Edit Watch Progress")
                        .navigationBarTitleDisplayMode(.inline)
                        .presentationDetents([.fraction(0.8)])
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
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(media.getTitle)
        .navigationBarTitleDisplayMode(.large)
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
                        userProgress.comments = media.getListStatus.getComments
                        
                        if (media.getListStatus.getStartDate != nil) {
                            userProgress.startDate = stringToDate(media.getListStatus.getStartDate!)
                        }
                        if (media.getListStatus.getEndDate != nil) {
                            userProgress.startDate = stringToDate(media.getListStatus.getEndDate!)
                        }
                    }
                    
                    if resultManager.mediaType == .manga {
                        media = try await mangaController.fetchDetails(id: media.id)
                        jikanCharacters = try await jikanCharacterController.fetchMangaCharacter(id: media.id)
                        
                        userProgress.progress = media.getListStatus.getReadChapters
                        userProgress.rating = media.getListStatus.getRating
                        
                        userProgress.end = media.getChapters
                        userProgress.comments = media.getListStatus.getComments
                        
                        userProgress.currentVolume = media.getListStatus.getReadVolumes
                        userProgress.volumes = media.getVolumes
                        
                        if (media.getListStatus.getStartDate != nil) {
                            userProgress.startDate = stringToDate(media.getListStatus.getStartDate!)
                        }
                        if (media.getListStatus.getEndDate != nil) {
                            userProgress.startDate = stringToDate(media.getListStatus.getEndDate!)
                        }
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
    
    private func stringToDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
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
                return sectionsManager.showGenres && !media.getGenres.isEmpty
            case .score:
                return sectionsManager.showScore
            case .related:
                return sectionsManager.showRelated && (!media.getRelatedAnimes.isEmpty || !media.getRelatedMangas.isEmpty)
                
            case .recommendations:
                return sectionsManager.showRecommendations && !media.getRecommendations.isEmpty
            case .characters:
                return sectionsManager.showCharacters && !jikanCharacters.data.isEmpty
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
