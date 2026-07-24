import SwiftUI

struct DetailsView: View {
    
    @State var media: MediaNode
    @State var isDescriptionExpanded = false
    @State private var isSheetPresented = false
    
    @State private var jikanCharacters: JikanCharacter = JikanCharacter(data: [])
    @State private var jikanRelations: [RelationEntry] = []
    
    @State private var userProgress = MyListStatus()
    
    @State private var showAlert = false
    
    @State private var showComments = false
    @State private var showStartDate = false
    @State private var showFinishDate = false
    
    @State private var startDate: Date?
    @State private var finishDate: Date?
    
    @State private var didTap = false
    
    @Environment(AppSettings.self)
    private var settings
    
    @Environment(ToastManager.self)
    private var toastManager
    
    @Environment(AccountSession.self)
    private var accountSession

    @Environment(MALDependencies.self)
    private var malDependencies

    private var isMALAuthenticated: Bool {
        accountSession.activeProvider == .myAnimeList
    }
    
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
                    if isMALAuthenticated {
                        if media.getEntryStatus != .notSet {
                            HStack(alignment: .center) {
                                VStack(spacing: 3) {
                                    Image(systemName: "star.fill")
                                        .font(.subheadline)
                                    Text("Rating")
                                        .font(.caption)
                                    Text(media.getMyListStatus.score, format: .number)
                                        .font(.body)
                                        .foregroundStyle(.primary)
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
                                if (media.isMangaOrAnime == .anime && media.getMyListStatus.watchedEpisodes != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "tv.fill")
                                            .font(.subheadline)
                                        Text("Episode")
                                            .font(.caption)
                                        Text(
                                            verbatim: media.episodes > 0
                                                ? "\(media.getMyListStatus.watchedEpisodes)/\(media.episodes)"
                                                : String(media.getMyListStatus.watchedEpisodes)
                                        )
                                        .font(.body)
                                        .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                if (media.isMangaOrAnime == .manga && media.getMyListStatus.readVolumes != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(
                                            systemName: "character.book.closed.fill.ja"
                                        )
                                        .font(.subheadline)
                                        Text("Volume")
                                            .font(.caption)
                                        Text(
                                            verbatim: media.volumes > 0
                                                ? "\(media.getMyListStatus.readVolumes)/\(media.volumes)"
                                                : String(media.getMyListStatus.readVolumes)
                                        )
                                        .font(.body)
                                        .accentColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                if (media.isMangaOrAnime == .manga && media.getMyListStatus.readChapters != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "book.pages.fill")
                                            .font(.subheadline)
                                        Text("Chapter")
                                            .font(.caption)
                                        Text(
                                            verbatim: media.chapters > 0
                                                ? "\(media.getMyListStatus.readChapters)/\(media.chapters)"
                                                : String(media.getMyListStatus.readChapters)
                                        )
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
                        } else {
                            Button {
                                didTap.toggle()
                                Task {
                                    toastManager.isLoading = true
                                    toastManager.showAddedToast = true
                                    defer {
                                        toastManager.isLoading = false
                                    }
                                    if (media.isMangaOrAnime == .anime) {
                                        try await malDependencies.animeController.addToWatchList(id: media.id)
                                        media = try await malDependencies.animeController.fetchDetails(id: media.id)
                                    }
                                    if (media.isMangaOrAnime == .manga) {
                                        try await malDependencies.mangaController.addToReadingList(id: media.id)
                                        media = try await malDependencies.mangaController.fetchDetails(id: media.id)
                                    }
                                    Metrics.entryAction(.added, format: media.isMangaOrAnime, mediaType: media.specificMediaType)
                                }
                            } label : {
                                Label("Add to Library",systemImage: "plus.circle.fill")
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
                            Text("Log in with your MyAnimeList account to see your \(media.specificMediaType.displayName) progress, rating, and status.")
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
                    Sections(media: media, jikanCharacters: jikanCharacters, jikanRelations: jikanRelations)
                }
            }
            .noScrollEdgeEffect()
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .toolbar {
                if media.getEntryStatus != .notSet {
                    ToolbarItem {
                        if #available(iOS 26.0, *) {
                            Button(role: .close) {
                                userProgress = media.getMyListStatus
                                isSheetPresented = true
                            } label: {
                                Image(systemName: "pencil")
                            }
                        } else {
                            Button {
                                userProgress = media.getMyListStatus
                                isSheetPresented = true
                            } label: {
                                Text("Edit")
                            }
                        }
                    }
                    
                    if #available(iOS 26.0, *) {
                        ToolbarSpacer(.fixed)
                    }
                }
                ToolbarItem {
                    if let url = URL(string: "https://myanimelist.net/\(media.isMangaOrAnime.rawValue)/\(media.id)") {
                        
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    } else {
                        Text("Invalid URL")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                NavigationStack {
                    List {
                        Section {
                            if media.isMangaOrAnime == .manga {
                                Picker("Progress", selection: $userProgress.progressStatus) {
                                    ForEach(
                                        [
                                            ProgressStatus.Manga.completed,
                                            .reading,
                                            .dropped,
                                            .onHold,
                                            .planToRead
                                        ],
                                        id: \.self
                                    ) { status in
                                        Text(status.displayName)
                                            .tag(status.rawValue)
                                    }
                                }
                            }

                            if media.isMangaOrAnime == .anime {
                                Picker("Progress", selection: $userProgress.progressStatus) {
                                    ForEach(
                                        [
                                            ProgressStatus.Anime.completed,
                                            .watching,
                                            .dropped,
                                            .onHold,
                                            .planToWatch
                                        ],
                                        id: \.self
                                    ) { status in
                                        Text(status.displayName)
                                            .tag(status.rawValue)
                                    }
                                }
                            }
                            
                            Picker("Rating", selection: $userProgress.score) {
                                ForEach(0...10, id: \.self) { rating in
                                    if let ratingValue = RatingValues(rawValue: rating) {
                                        Text(ratingValue.displayName)
                                            .tag(rating)
                                    }
                                }
                            }
                            
                            Group {
                                Picker(selection: $userProgress.readChapters, label:
                                        VStack(alignment: .leading, spacing: 4) {
                                    Text("Chapter")
                                    Text(verbatim: "\(userProgress.readChapters)/\(media.chapters)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                ) {
                                    ForEach(0...media.chapters, id: \.self) { chapter in
                                        Text(chapter, format: .number).tag(chapter)
                                    }
                                }
                                .isVisible(media.chapters != 0 && (settings.mangaFormat == .chapter || settings.mangaFormat == .both))
                                
                                
                                LabeledContent("Chapter") {
                                    HStack(spacing: 0) {
                                        Button {
                                            userProgress.readChapters -= 1
                                        } label: {
                                            Image(systemName: "minus")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .buttonStyle(.plain)
                                        .disabled(userProgress.readChapters == 0)
                                        
                                        Divider()
                                        
                                        TextField("Chapter", value: $userProgress.readChapters, format: .number)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        
                                        Divider()
                                        
                                        Button {
                                            userProgress.readChapters += 1
                                        } label: {
                                            Image(systemName: "plus")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .frame(width: 170, height: 35)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(Color(uiColor: .secondarySystemFill))
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    )
                                }
                                .isVisible(
                                    media.chapters == 0 &&
                                    (settings.mangaFormat == .chapter || settings.mangaFormat == .both)
                                )
                                
                                Picker(selection: $userProgress.readVolumes, label:
                                        VStack(alignment: .leading, spacing: 4) {
                                    Text("Volume")
                                    Text(verbatim: "\(userProgress.readVolumes)/\(media.volumes)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                ) {
                                    ForEach(0...media.volumes, id: \.self) { volume in
                                        Text(volume, format: .number).tag(volume)
                                    }
                                }
                                .isVisible(media.volumes != 0 && (settings.mangaFormat == .volume || settings.mangaFormat == .both))
                                
                                LabeledContent("Volume") {
                                    HStack(spacing: 0) {
                                        Button {
                                            userProgress.readVolumes -= 1
                                        } label: {
                                            Image(systemName: "minus")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .buttonStyle(.plain)
                                        .disabled(userProgress.readVolumes == 0)
                                        
                                        Divider()
                                        
                                        TextField("Volume", value: $userProgress.readVolumes, format: .number)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        
                                        Divider()
                                        
                                        Button {
                                            userProgress.readVolumes += 1
                                        } label: {
                                            Image(systemName: "plus")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .frame(width: 170, height: 35)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(Color(uiColor: .secondarySystemFill))
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    )
                                }
                                .isVisible(
                                    media.volumes == 0 &&
                                    (settings.mangaFormat == .volume || settings.mangaFormat == .both)
                                )
                            }
                            .isVisible(media.isMangaOrAnime == .manga)
                            
                            Picker(selection: $userProgress.watchedEpisodes, label:
                                    VStack(alignment: .leading, spacing: 4) {
                                Text("Episode")
                                Text(verbatim: "\(userProgress.watchedEpisodes)/\(media.episodes)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            ) {
                                ForEach(0...media.episodes, id: \.self) { episode in
                                    Text(episode, format: .number).tag(episode)
                                }
                            }
                            .isVisible(media.isMangaOrAnime == .anime && media.episodes != 0)
                            
                            LabeledContent("Episode") {
                                HStack(spacing: 0) {
                                    Button {
                                        userProgress.watchedEpisodes -= 1
                                    } label: {
                                        Image(systemName: "minus")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(userProgress.watchedEpisodes == 0)
                                    
                                    Divider()
                                    
                                    TextField("Episode", value: $userProgress.watchedEpisodes, format: .number)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .labelsHidden()
                                    
                                    Divider()
                                    
                                    Button {
                                        userProgress.watchedEpisodes += 1
                                    } label: {
                                        Image(systemName: "plus")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(width: 170, height: 35)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(uiColor: .secondarySystemFill))
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                )
                            }
                            .isVisible(media.episodes == 0 && media.isMangaOrAnime == .anime)
                        }
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Priority")
                                
                                Picker("Priority", selection: $userProgress.priority) {
                                    ForEach(PriorityValues.allCases, id: \.self) { priority in
                                        Text(priority.displayName)
                                            .tag(priority.rawValue)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .labelsHidden()
                            }
                        }
                        .isVisible(settings.advancedMode)
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    showComments.toggle()
                                    if !showComments {
                                        if media.isMangaOrAnime == .anime {
                                            userProgress.userComments = ""
                                        } else {
                                            userProgress.userComments = ""
                                        }
                                    }
                                }
                            }
                            ){
                                Label {
                                    Text(showComments ? "Clear Notes" : "Add Notes")
                                } icon: {
                                    Image(systemName: showComments ? "minus.circle.fill" : "plus.circle.fill")
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundStyle(showComments ? .red : Color.getByColorString(settings.accentColor.rawValue))
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if showComments {
                                if (media.isMangaOrAnime == .anime) {
                                    TextField("Comments", text: $userProgress.userComments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                } else {
                                    TextField("Comments", text: $userProgress.userComments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        .isVisible(settings.advancedMode)
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    showStartDate.toggle()
                                    if !showStartDate {
                                        startDate = nil
                                    }
                                }
                            }) {
                                Label {
                                    Text(showStartDate ? "Clear Start Date" : "Add Start Date")
                                } icon: {
                                    Image(systemName: showStartDate ? "calendar.badge.minus" : "calendar.badge.plus")
                                        .foregroundStyle(showStartDate ? .red : Color.getByColorString(settings.accentColor.rawValue))
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if showStartDate {
                                DatePicker(
                                    "Start Date",
                                    selection: Binding(
                                        get: { startDate ?? Date() },
                                        set: { startDate = $0 }
                                    ),
                                    displayedComponents: .date
                                ).transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            
                            Button(action: {
                                withAnimation {
                                    showFinishDate.toggle()
                                    if !showFinishDate {
                                        finishDate = nil
                                    }
                                }
                            }) {
                                Label {
                                    Text(showFinishDate ? "Clear Finish Date" : "Add Finish Date")
                                } icon: {
                                    Image(systemName: showFinishDate ? "calendar.badge.minus" : "calendar.badge.plus")
                                        .foregroundStyle(showFinishDate ? .red : Color.getByColorString(settings.accentColor.rawValue))
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if showFinishDate {
                                DatePicker(
                                    "Finish Date",
                                    selection: Binding(
                                        get: { finishDate ?? Date() },
                                        set: { finishDate = $0 }
                                    ),
                                    displayedComponents: .date
                                )
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .isVisible(settings.advancedMode)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            if #available(iOS 26, *) {
                                Button(role: .confirm) {
                                    Task {
                                        if (media.isMangaOrAnime == .manga) {
                                            try await malDependencies.mangaController
                                                .saveProgress(
                                                    id: media.id,
                                                    status: userProgress.progressStatus,
                                                    score: userProgress.score,
                                                    chapters: userProgress.readChapters,
                                                    volumes: userProgress.readVolumes,
                                                    comments: userProgress.userComments,
                                                    startDate: startDate,
                                                    finishDate: finishDate
                                                )
                                            media = try await malDependencies.mangaController.fetchDetails(id: media.id)
                                        }
                                        if (media.isMangaOrAnime == .anime) {
                                            try await malDependencies.animeController
                                                .saveProgress(
                                                    id: media.id,
                                                    status: userProgress.progressStatus,
                                                    score: userProgress.score,
                                                    episodes: userProgress.watchedEpisodes,
                                                    comments: userProgress.userComments,
                                                    startDate: startDate,
                                                    finishDate: finishDate
                                                )
                                            media = try await malDependencies.animeController.fetchDetails(id: media.id)
                                        }
                                        toastManager.showUpdatedToast = true
                                        isSheetPresented = false
                                        Metrics.entryAction(.updated, format: media.isMangaOrAnime, mediaType: media.specificMediaType)
                                    }
                                }
                                .tint(Color.getByColorString(settings.accentColor.rawValue)
                                )
                            } else {
                                Button("Save") {
                                    Task {
                                        if (media.isMangaOrAnime == .manga) {
                                            try await malDependencies.mangaController
                                                .saveProgress(
                                                    id: media.id,
                                                    status: userProgress.progressStatus,
                                                    score: userProgress.score,
                                                    chapters: userProgress.readChapters,
                                                    volumes: userProgress.readVolumes,
                                                    comments: userProgress.userComments,
                                                    startDate: startDate,
                                                    finishDate: finishDate
                                                )
                                            media = try await malDependencies.mangaController.fetchDetails(id: media.id)
                                        }
                                        if (media.isMangaOrAnime == .anime) {
                                            try await malDependencies.animeController
                                                .saveProgress(
                                                    id: media.id,
                                                    status: userProgress.progressStatus,
                                                    score: userProgress.score,
                                                    episodes: userProgress.watchedEpisodes,
                                                    comments: userProgress.userComments,
                                                    startDate: startDate,
                                                    finishDate: finishDate
                                                )
                                            media = try await malDependencies.animeController.fetchDetails(id: media.id)
                                        }
                                        toastManager.showUpdatedToast = true
                                        isSheetPresented = false
                                        Metrics.entryAction(.updated, format: media.isMangaOrAnime, mediaType: media.specificMediaType)
                                    }
                                }
                                .foregroundStyle(Color.getByColorString(settings.accentColor.rawValue))
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Group {
                                if #available(iOS 26, *) {
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
                            .alert("Remove Entry",isPresented: $showAlert) {
                                Button("Delete", role: .destructive) {
                                    didTap.toggle()
                                    Task {
                                        if (media.isMangaOrAnime == .manga) {
                                            try await malDependencies.mangaController.deleteEntry(id: media.id)
                                            toastManager.showRemovedToast = true
                                            media = try await malDependencies.mangaController.fetchDetails(id: media.id)
                                        }
                                        if (media.isMangaOrAnime == .anime) {
                                            try await malDependencies.animeController.deleteEntry(id: media.id)
                                            toastManager.showRemovedToast = true
                                            media = try await malDependencies.animeController.fetchDetails(id: media.id)
                                        }
                                        showAlert = false
                                        isSheetPresented = false
                                        Metrics.entryAction(.deleted, format: media.isMangaOrAnime, mediaType: media.specificMediaType)
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("Do you really want to remove \(media.preferredTitle) from your library?")
                            }.sensoryFeedback(.warning, trigger: didTap)
                        }
                    }
                    .navigationTitle(media.isMangaOrAnime == .manga ? "Edit Reading Progress" : "Edit Watch Progress")
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationDetents([settings.advancedMode ? .fraction(0.8) : .fraction(0.6)])
                    .presentationBackgroundInteraction(.disabled)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.regularMaterial)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(media.preferredTitle)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                toastManager.isLoading = true
                defer { toastManager.isLoading = false }
                do {
                    if media.isMangaOrAnime == .anime {
                        media = try await malDependencies.animeController.fetchDetails(id: media.id)
                        
                        if settings.isExtendedDataEnabled {
                            jikanCharacters = try await jikanCharacterController.fetchAnimeCharacter(id: media.id, apiService: settings.extendedDataSource)
                            jikanRelations = try await jikanRelationsController.fetchAnimeRelations(id: media.id, apiService: settings.extendedDataSource)
                        }
                    }
                    
                    if media.isMangaOrAnime == .manga {
                        media = try await malDependencies.mangaController.fetchDetails(id: media.id)
                        
                        if settings.isExtendedDataEnabled {
                            jikanCharacters = try await jikanCharacterController.fetchMangaCharacter(id: media.id, apiService: settings.extendedDataSource)
                            jikanRelations = try await jikanRelationsController.fetchMangaRelations(id: media.id, apiService: settings.extendedDataSource)
                        }
                    }
                    userProgress = media.getMyListStatus
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
            minutes: media.averageEpisodeDurationInMinutes,
            numberOfChapters: media.chapters,
            numberOfVolumes: media.volumes,
            startDate: media.releaseStartDate,
            endDate: media.releaseEndDate,
            studios: media.studiosList,
            authors: media.authorsList,
            status: media.specificStatus
        )
        GenresView(
            genres: media.genresList,
            mode: media.isMangaOrAnime
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
