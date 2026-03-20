import SwiftUI

struct DetailsView: View {
    
    @State var media: MediaNode
    @State var isDescriptionExpanded = false
    @State private var isSheetPresented = false
    
    @State private var jikanCharacters: JikanCharacter = JikanCharacter(
        data: []
    )
    @State private var jikanRelations: [RelationEntry] = []
    
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
    let jikanRelationsController = JikanRelationsController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    CoverSummaryView(
                        title: media.preferredTitle,
                        imageUrl: media.mainPicture.largeUrl,
                        score: media.meanValue,
                        chapters: media.chapters,
                        volumes: media.volumes,
                        episodes: media.episodes,
                        summary: media.synopsisText,
                        type: media.specificMediaType
                    )
                    if tokenHandler.isAuthenticated {
                        if media.getEntryStatus != .unknown {
                            HStack(alignment: .center) {
                                VStack(spacing: 3) {
                                    Image(systemName: "star.fill")
                                        .font(.subheadline)
                                    
                                    Text("Rating")
                                        .font(.caption)
                                    
                                    Text("\(media.getMyListStatus.score)")
                                        .font(.body)
                                        .accentColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                Divider()
                                VStack(spacing: 3) {
                                    media.getEntryStatus.libraryIcon
                                    
                                    Text("Status")
                                        .font(.caption)
                                    
                                    Text(media.getEntryStatus.displayName)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .font(.callout)
                                        .accentColor(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                if (
                                    media.isMangaOrAnime == .anime && media.getMyListStatus.watchedEpisodes != 0
                                ) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "tv.fill")
                                            .font(.subheadline)
                                        
                                        Text("Episode")
                                            .font(.caption)
                                        
                                        Text(
                                            "\(media.getMyListStatus.watchedEpisodes)\(media.episodes != 0 ? "/\(media.episodes)" : "")"
                                        )
                                        .font(.body)
                                        .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                if (
                                    media.isMangaOrAnime == .manga && media.getMyListStatus.readVolumes != 0
                                ) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(
                                            systemName: "character.book.closed.fill.ja"
                                        )
                                        .font(.subheadline)
                                        
                                        Text("Volume")
                                            .font(.caption)
                                        
                                        Text(
                                            "\(media.getMyListStatus.readVolumes)\(media.volumes != 0 ? "/\(media.volumes)" : "")"
                                        )
                                        .font(.body)
                                        .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                if (
                                    media.isMangaOrAnime == .manga && media.getMyListStatus.readChapters != 0
                                ) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "book.pages.fill")
                                            .font(.subheadline)
                                        
                                        Text("Chapter")
                                            .font(.caption)
                                        
                                        Text(
                                            "\(media.getMyListStatus.readChapters)\(media.chapters != 0 ? "/\(media.chapters)" : "")"
                                        )
                                        .font(.body)
                                        .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding([.top, .bottom], 8)
                            .background(
                                Color(.secondarySystemGroupedBackground)
                            )
                            .cornerRadius(12)
                            .padding(.horizontal)
                        } else {
                            Button {
                                didTap.toggle()
                                Task {
                                    alertManager.isLoading = true
                                    alertManager.showAddedAlert = true
                                    defer {
                                        alertManager.isLoading = false
                                    }
                                    if (media.isMangaOrAnime == .anime) {
                                        try await animeController
                                            .addToWatchList(id: media.id)
                                        media = try await animeController
                                            .fetchDetails(id: media.id)
                                    }
                                    if (media.isMangaOrAnime == .manga) {
                                        try await mangaController
                                            .addToReadingList(id: media.id)
                                        media = try await mangaController
                                            .fetchDetails(id: media.id)
                                    }
                                }
                            } label : {
                                Label(
                                    "Add to library",
                                    systemImage: "plus.circle.fill"
                                )
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .padding(.vertical, 4)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .borderedProminentOrGlassProminent()
                            .sensoryFeedback(.success, trigger: didTap)
                        }
                    } else {
                        GroupBox {
                            Text(
                                "Log in with your MyAnimeList account to see your \(media.specificMediaType.displayName) progress, rating, and status."
                            )
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        } label: {
                            Label("Info", systemImage: "info.circle")
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .backgroundStyle(
                            Color(.secondarySystemGroupedBackground)
                        )
                    }
                    Sections(
                        media: media,
                        jikanCharacters: jikanCharacters,
                        jikanRelations: jikanRelations
                    )
                }
            }
            .noScrollEdgeEffect()
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .toolbar {
                if media.getEntryStatus != .unknown {
                    ToolbarItem {
                        if #available(iOS 26.0, *) {
                            Button(role: .close, action: {
                                isSheetPresented = true
                            }) {
                                Image(systemName: "pencil")
                            }

                        } else {
                            Button(action: {
                                isSheetPresented = true
                            }) {
                                Text("Edit")
                            }
                        }
                    }
                    
                    if #available(iOS 26.0, *) {
                        ToolbarSpacer(.fixed)
                    }
                }
                ToolbarItem {
                    let escapedTitle = media.title.replacingOccurrences(
                        of: " ",
                        with: "_"
                    )
                    
                    if let url = URL(
                        string: "https://myanimelist.net/\(media.isMangaOrAnime.rawValue)/\(media.id)/\(escapedTitle)"
                    ) {
                        
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
                            if (media.isMangaOrAnime == .manga) {
                                Section {
                                    Picker(
                                        "Progress",
                                        selection: $userProgress.mangaProgress
                                    ) {
                                        ForEach(
                                            [
                                                ProgressStatus.Manga.completed,
                                                .reading,
                                                .dropped,
                                                .onHold,
                                                .planToRead
                                            ],
                                            id: \.self
                                        ) { mangaSelection in
                                            Text(mangaSelection.displayName)
                                                .tag(mangaSelection)
                                        }
                                    }
                                    
                                    Picker(
                                        "Rating",
                                        selection: $userProgress.rating
                                    ) {
                                        ForEach(0...10, id: \.self) { rating in
                                            if let ratingValue = RatingValues(
                                                rawValue: rating
                                            ) {
                                                Text(ratingValue.displayName)
                                                    .tag(rating)
                                            } else {
                                                Text("Unknown")
                                            }
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Mode")
                                        
                                        Picker(
                                            "Mode",
                                            selection: $settingsManager.mangaMode
                                        ) {
                                            ForEach(
                                                MangaMode.allCases,
                                                id: \.self
                                            ) { mode in
                                                Text(mode.displayName).tag(mode)
                                            }
                                        }
                                        .pickerStyle(.segmented)
                                    }
                                    
                                    if (
                                        settingsManager.mangaMode == MangaMode.all
                                    ) {
                                        if userProgress.end != 0 {
                                            Picker(
selection: $userProgress.progress,
label:
    VStack(
        alignment: .leading,
        spacing: 4
    ) {
        Text("Chapter")
        Text("\(userProgress.progress)/\(userProgress.end)")
            .foregroundStyle(.secondary)
            .font(.caption)
            .fontWeight(.bold)
    }
                                            ) {
                                                ForEach(
                                                    0...userProgress.end,
                                                    id: \.self
                                                ) { chapter in
                                                    Text("\(chapter)")
                                                        .tag(chapter)
                                                }
                                            }
                                        } else {
                                            Stepper(
                                                value: $userProgress.progress,
                                                in: 0...Int.max
                                            ) {
                                                VStack(
                                                    alignment: .leading,
                                                    spacing: 4
                                                ) {
                                                    Text("Chapter")
                                                    
                                                    Text(
                                                        "\(userProgress.progress)"
                                                    )
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    
                                                }
                                            }
                                        }
                                        
                                        if userProgress.volumes != 0 {
                                            Picker(
selection: $userProgress.currentVolume,
label:
    VStack(
        alignment: .leading,
        spacing: 4
    ) {
        Text("Volume")
        Text("\(userProgress.currentVolume)/\(userProgress.volumes)")
            .foregroundStyle(.secondary)
            .font(.caption)
            .fontWeight(.bold)
    }
                                            ) {
                                                ForEach(
                                                    0...userProgress.volumes,
                                                    id: \.self
                                                ) { volume in
                                                    Text("\(volume)")
                                                        .tag(volume)
                                                }
                                            }
                                        } else {
                                            Stepper(
                                                value: $userProgress.currentVolume,
                                                in: 0...Int.max
                                            ) {
                                                VStack(
                                                    alignment: .leading,
                                                    spacing: 4
                                                ) {
                                                    Text("Volume")
                                                    
                                                    Text(
                                                        "\(userProgress.currentVolume)"
                                                    )
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                }
                                            }
                                        }
                                    }
                                    
                                    if (
                                        settingsManager.mangaMode == MangaMode.chapter
                                    ) {
                                        if userProgress.end != 0 {
                                            Picker(
selection: $userProgress.progress,
label:
    VStack(
        alignment: .leading,
        spacing: 4
    ) {
        Text("Chapter")
        Text("\(userProgress.progress)/\(userProgress.end)")
            .foregroundStyle(.secondary)
            .font(.caption)
            .fontWeight(.bold)
    }
                                            ) {
                                                ForEach(
                                                    0...userProgress.end,
                                                    id: \.self
                                                ) { chapter in
                                                    Text("\(chapter)")
                                                        .tag(chapter)
                                                }
                                            }
                                        } else {
                                            Stepper(
                                                value: $userProgress.progress,
                                                in: 0...Int.max
                                            ) {
                                                VStack(
                                                    alignment: .leading,
                                                    spacing: 4
                                                ) {
                                                    Text("Chapter")
                                                    
                                                    Text(
                                                        "\(userProgress.progress)"
                                                    )
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    
                                                }
                                            }
                                        }
                                    }
                                    if (
                                        settingsManager.mangaMode == MangaMode.volume
                                    ) {
                                        if userProgress.volumes != 0 {
                                            Picker(
selection: $userProgress.currentVolume,
label:
    VStack(
        alignment: .leading,
        spacing: 4
    ) {
        Text("Volume")
        Text("\(userProgress.currentVolume)/\(userProgress.volumes)")
            .foregroundStyle(.secondary)
            .font(.caption)
            .fontWeight(.bold)
    }
                                            ) {
                                                ForEach(
                                                    0...userProgress.volumes,
                                                    id: \.self
                                                ) { volume in
                                                    Text("\(volume)")
                                                        .tag(volume)
                                                }
                                            }
                                        } else {
                                            Stepper(
                                                value: $userProgress.currentVolume,
                                                in: 0...Int.max
                                            ) {
                                                VStack(
                                                    alignment: .leading,
                                                    spacing: 4
                                                ) {
                                                    Text("Volume")
                                                    
                                                    Text(
                                                        "\(userProgress.currentVolume)"
                                                    )
                                                    .foregroundStyle(.secondary)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if (media.isMangaOrAnime == .anime){
                                Picker(
                                    "Status",
                                    selection: $userProgress.animeProgress
                                ) {
                                    ForEach(
                                        [
                                            ProgressStatus.Anime.completed,
                                            .watching,
                                            .dropped,
                                            .onHold,
                                            .planToWatch
                                        ],
                                        id: \.self
                                    ) { animeSelection in
                                        Text(animeSelection.displayName)
                                            .tag(animeSelection)
                                    }
                                }
                                
                                Picker(
                                    "Rating",
                                    selection: $userProgress.rating
                                ) {
                                    ForEach(0...10, id: \.self) { rating in
                                        if let ratingValue = RatingValues(
                                            rawValue: rating
                                        ) {
                                            Text(ratingValue.displayName)
                                                .tag(rating)
                                        } else {
                                            Text("Unknown")
                                        }
                                    }
                                }
                                
                                if userProgress.end != 0 {
                                    Picker(
selection: $userProgress.progress,
label:
    VStack(
        alignment: .leading,
        spacing: 4
    ) {
        Text("Episode")
        Text("\(userProgress.progress)/\(userProgress.end)")
            .foregroundStyle(.secondary)
            .font(.caption)
            .fontWeight(.bold)
    }) {
        ForEach(0...userProgress.end, id: \.self) { episode in
            Text("\(episode)").tag(episode)
        }
    }
                                } else {
                                    Stepper(
                                        "Episode \(userProgress.progress)",
                                        value: $userProgress.progress,
                                        in: 0...Int.max
                                    )
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
                                        Text(
                                            showComments ? "Remove comments" : "Add comments"
                                        )
                                    } icon: {
                                        Image(
                                            systemName: showComments ? "minus.circle.fill" : "plus.circle.fill"
                                        )
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundStyle(
                                            showComments ? .red : Color
                                                .getByColorString(
                                                    settingsManager.accentColor.rawValue
                                                )
                                        )
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if showComments {
                                    TextField(
                                        "Comments",
                                        text: $userProgress.comments
                                    )
                                    .transition(
                                        .opacity
                                            .combined(with: .move(edge: .top))
                                    )
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
                                        Text(
                                            showStartDate ? "Remove start date" : "Add start date"
                                        )
                                    } icon: {
                                        Image(
                                            systemName: showStartDate ? "calendar.badge.minus" : "calendar.badge.plus"
                                        )
                                        .foregroundStyle(
                                            showStartDate ? .red : Color
                                                .getByColorString(
                                                    settingsManager.accentColor.rawValue
                                                )
                                        )
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if showStartDate {
                                    DatePicker(
                                        "Start date",
                                        selection: Binding(
                                            get: {
                                                userProgress.startDate ?? Date()
                                            },
                                            set: { userProgress.startDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                    .transition(
                                        .opacity
                                            .combined(with: .move(edge: .top))
                                    )
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
                                        Text(
                                            showFinishDate ? "Remove finish date" : "Add finish date"
                                        )
                                    } icon: {
                                        Image(
                                            systemName: showFinishDate ? "calendar.badge.minus" : "calendar.badge.plus"
                                        )
                                        .foregroundStyle(
                                            showFinishDate ? .red : Color
                                                .getByColorString(
                                                    settingsManager.accentColor.rawValue
                                                )
                                        )
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if showFinishDate {
                                    DatePicker(
                                        "Finish date",
                                        selection: Binding(
                                            get: {
                                                userProgress.endDate ?? Date()
                                            },
                                            set: { userProgress.endDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                    .transition(
                                        .opacity
                                            .combined(with: .move(edge: .top))
                                    )
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .padding(.horizontal)
                        .scrollContentBackground(.hidden)
                        .scrollBounceBehavior(.basedOnSize)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                if #available(iOS 26.0, *) {
                                    Button(role: .confirm) {
                                        Task {
                                            if (
                                                media.isMangaOrAnime == .manga
                                            ) {
                                                try await mangaController
                                                    .saveProgress(
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
                                                media = try await mangaController
                                                    .fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                            if (
                                                media.isMangaOrAnime == .anime
                                            ) {
                                                try await animeController
                                                    .saveProgress(
                                                        id: media.id,
                                                        status: userProgress.animeProgress.rawValue,
                                                        score: userProgress.rating,
                                                        episodes: userProgress.progress,
                                                        comments: userProgress.comments,
                                                        startDate: userProgress.startDate,
                                                        finishDate: userProgress.endDate
                                                    )
                                                alertManager.showUpdatedAlert = true
                                                media = try await animeController
                                                    .fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                        }
                                    }
                                    .tint(
                                        Color
                                            .getByColorString(
                                                settingsManager.accentColor.rawValue
                                            )
                                    )
                                } else {
                                    Button("Save") {
                                        Task {
                                            if (
                                                media.isMangaOrAnime == .manga
                                            ) {
                                                try await mangaController
                                                    .saveProgress(
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
                                                media = try await mangaController
                                                    .fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                            if (
                                                media.isMangaOrAnime == .anime
                                            ) {
                                                try await animeController
                                                    .saveProgress(
                                                        id: media.id,
                                                        status: userProgress.animeProgress.rawValue,
                                                        score: userProgress.rating,
                                                        episodes: userProgress.progress,
                                                        comments: userProgress.comments,
                                                        startDate: userProgress.startDate,
                                                        finishDate: userProgress.endDate
                                                    )
                                                alertManager.showUpdatedAlert = true
                                                media = try await animeController
                                                    .fetchDetails(id: media.id)
                                                isSheetPresented = false
                                            }
                                        }
                                    }
                                    .foregroundStyle(
                                        Color
                                            .getByColorString(
                                                settingsManager.accentColor.rawValue
                                            )
                                    )
                                }
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Group {
                                    if #available(iOS 26.0, *) {
                                        Button(role: .destructive) {
                                            showAlert = true
                                        }
                                    } else {
                                        Button(action: {
                                            showAlert = true
                                        }) {
                                            Image(systemName: "trash")
                                                .symbolRenderingMode(.palette)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .alert(
                                    "Delete progress",
                                    isPresented: $showAlert
                                ) {
                                    Button("Delete", role: .destructive) {
                                        didTap.toggle()
                                        Task {
                                            if(media.isMangaOrAnime == .manga) {
                                                try await mangaController
                                                    .deleteEntry(id: media.id)
                                                alertManager.showRemovedAlert = true
                                                media = try await mangaController
                                                    .fetchDetails(id: media.id)
                                            }
                                            if(media.isMangaOrAnime == .anime) {
                                                try await animeController
                                                    .deleteEntry(id: media.id)
                                                alertManager.showRemovedAlert = true
                                                media = try await animeController
                                                    .fetchDetails(id: media.id)
                                            }
                                            showAlert = false
                                            isSheetPresented = false
                                        }
                                    }
                                    Button("Cancel", role: .cancel) {}
                                } message: {
                                    Text(
                                        "Do you really want to delete your progress for \(media.preferredTitle)?"
                                    )
                                }.sensoryFeedback(.warning, trigger: didTap)
                            }
                        }
                        .navigationTitle(
                            media.isMangaOrAnime == .manga ? "Edit Reading Progress" : "Edit Watch Progress"
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .presentationDetents([.fraction(0.8)])
                        .presentationBackgroundInteraction(.disabled)
                        .presentationBackground(.regularMaterial)
                    }
                }
                else {
                    GroupBox {
                        Text(
                            "Log in with your MyAnimeList account to be able to edit \(media.preferredTitle)'s progress, rating and progress status."
                        )
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
        .navigationTitle(media.preferredTitle)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                do {
                    if media.isMangaOrAnime == .anime {
                        media = try await animeController
                            .fetchDetails(id: media.id)
                        
                        jikanCharacters = try await jikanCharacterController
                            .fetchAnimeCharacter(id: media.id)
                        jikanRelations = try await jikanRelationsController
                            .fetchAnimeRelations(id: media.id)
                        
                        userProgress.progress = media.getMyListStatus.watchedEpisodes
                        userProgress.rating = media.getMyListStatus.score
                        userProgress.end = media.episodes
                        userProgress.comments = media.getMyListStatus.userComments
                        
                        if (media.getMyListStatus.startDate != nil) {
                            userProgress.startDate = Date.from(
                                media.getMyListStatus.startDate!
                            )
                        }
                        if (media.getMyListStatus.finishDate != nil) {
                            userProgress.endDate = Date.from(
                                media.getMyListStatus.finishDate!
                            )
                        }
                    }
                    
                    if media.isMangaOrAnime == .manga {
                        media = try await mangaController
                            .fetchDetails(id: media.id)
                        jikanCharacters = try await jikanCharacterController
                            .fetchMangaCharacter(id: media.id)
                        jikanRelations = try await jikanRelationsController
                            .fetchMangaRelations(id: media.id)
                        
                        userProgress.progress = media.getMyListStatus.readChapters
                        userProgress.rating = media.getMyListStatus.score
                        
                        userProgress.end = media.chapters
                        userProgress.comments = media.getMyListStatus.userComments
                        
                        userProgress.currentVolume = media.getMyListStatus.readVolumes
                        userProgress.volumes = media.volumes
                        
                        if (media.getMyListStatus.startDate != nil) {
                            userProgress.startDate = Date.from(
                                media.getMyListStatus.startDate!
                            )
                        }
                        if (media.getMyListStatus.finishDate != nil) {
                            userProgress.endDate = Date.from(
                                media.getMyListStatus.finishDate!
                            )
                        }
                    }
                    
                    let wrapper = media.getEntryStatus
                    
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
    let media: MediaNode
    let jikanCharacters: JikanCharacter
    let jikanRelations: [RelationEntry]
    
    var body: some View {
        GeneralOverviewView(
            type: media.specificMediaType,
            episodes: media.episodes,
            numberOfChapters: media.chapters,
            numberOfVolumes: media.volumes,
            startDate: media.releaseStartDate,
            minutes: media.averageEpisodeDurationInMinutes,
            endDate: media.releaseEndDate,
            studios: media.studiosList,
            authors: media.authorsList,
            status: media.specificStatus
        )
        GenresView(
            genres: media.genresList,
            mode: media.specificMediaType.displayName.lowercased()
        )
        StatisticsView(
            score: media.mean ?? 0.0,
            rank: media.rank ?? 0,
            popularity: media.popularity ?? 0,
            users: media.listUserCount
        )
        OriginView(relations: jikanRelations)
        RelatedMediaView(media: media, seriesType: media.isMangaOrAnime)
        RecommendationsView(recommendations: media.recommendationsList)
        CharactersView(
            characters: jikanCharacters.data,
            seriesType: media.isMangaOrAnime
        )
    }
}
