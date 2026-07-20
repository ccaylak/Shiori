import SwiftUI
import SwiftData

struct LibraryView: View {
    
    @AppStorage("animeScheduleLastRefresh")
    private var animeScheduleLastRefresh: Double = 0
    
    @State private var library = MediaResponse(data: [], paging: nil)
    
    @State private var selectedMedia: Media?
    
    @State private var libraryEntry = MyListStatus()
    
    @State private var showAlert = false
    @State private var searchTerm = ""
    
    @State private var showComments = false
    
    @State private var showStartDate = false
    @State private var showFinishDate = false
    
    @State private var startDate: Date?
    @State private var finishDate: Date?
    
    @State private var loadingMediaID: Int?
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    private let aniListController = AniListController()
    
    @StateObject private var libraryManager: LibraryManager = .shared
    @EnvironmentObject private var toastManager: ToastManager
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    @State private var detailMedia: MediaNode?
    @State private var pendingDetailMedia: MediaNode?
    
    @Environment(\.modelContext)
    private var modelContext
    
    @AppStorage("isNoticationSetupDismissed")
    private var isNoticationSetupDismissed: Bool = false
    
    @State private var showNotificationSetupSheet: Bool = false
    
    private var filteredLibraryData: [Media] {
        if searchTerm.isEmpty {
            return library.data
        } else {
            return library.data.filter { media in
                media.node.preferredTitle.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    private var shouldReverseResultLocally: Bool {
        switch libraryManager.mediaType {
        case .manga:
            return libraryManager.mangaSortOrder.apiDirection != libraryManager.sortDirection
            
        case .anime:
            return libraryManager.animeSortOrder.apiDirection != libraryManager.sortDirection
        }
    }

    private var displayedLibraryData: [Media] {
        if shouldReverseResultLocally {
            return Array(filteredLibraryData.reversed())
        } else {
            return filteredLibraryData
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if tokenHandler.isAuthenticated {
                    ForEach(displayedLibraryData) { media in
                        Button(action: {
                            selectedMedia = media
                            loadingMediaID = media.node.id
                        }) {
                            LibraryMediaView(
                                malId: media.node.id,
                                title: media.node.preferredTitle,
                                image: media.node.mainPicture.largeUrl,
                                release: media.node.isMangaOrAnime == .anime ? media.node.getStartSeason.seasonLabel : media.node.yearLabel,
                                type: media.node.specificMediaType,
                                score: media.node.getMyListStatus.score,
                                progress: LibraryMediaProgress(
                                    current: media.node.isMangaOrAnime == .anime ? media.node.getMyListStatus.watchedEpisodes : media.node.getMyListStatus.readChapters,
                                    total: media.node.isMangaOrAnime == .anime ? media.node.episodes : media.node.chapters,
                                    secondaryCurrent: media.node.getMyListStatus.readVolumes,
                                    secondaryTotal: media.node.volumes
                                ),
                                episodeDurationInMinutes: media.node.averageEpisodeDurationInMinutes,
                                completed: media.node.getMyListStatus.progressStatus == "completed" ? true : false
                            ).overlay(
                                Group {
                                    if loadingMediaID == media.node.id {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                }
                            )
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                Task {
                                    try await mangaController.completeEntry(id: media.node.id)
                                    
                                    toastManager.showUpdatedToast = true
                                    library = try await mangaController.fetchLibrary()
                                }
                            } label : {
                                Label("Completed", systemImage: "checkmark")
                            }
                            .tint(.green)
                            .isVisible(media.node.isMangaOrAnime == .manga && media.node.getEntryStatus != ProgressStatus.manga(.completed))
                            
                            Button {
                                Task {
                                    try await animeController.completeEntry(id: media.node.id)
                                    
                                    toastManager.showUpdatedToast = true
                                    library = try await animeController.fetchLibrary()
                                }
                            } label: {
                                Label("Completed", systemImage: "checkmark")
                                    .bold()
                            }
                            .tint(.green)
                            .isVisible(media.node.isMangaOrAnime == .anime && media.node.getEntryStatus != ProgressStatus.anime(.completed))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            let currentChapter = media.node.getMyListStatus.readChapters
                            let totalChapters = media.node.chapters
                            
                            let currentVolume = media.node.getMyListStatus.readVolumes
                            let totalVolumes = media.node.volumes
                            
                            Button {
                                Task {
                                    let updatedChapterValue = {
                                        if totalChapters > 0 {
                                            return min(currentChapter + 1, totalChapters)
                                        } else {
                                            return currentChapter + 1
                                        }
                                    }()
                                    
                                    if updatedChapterValue > currentChapter {
                                        try await mangaController.increaseChapters(id: media.node.id, chapter: updatedChapterValue)
                                        
                                        toastManager.showUpdatedToast = true
                                        library = try await mangaController.fetchLibrary()
                                    }
                                }
                            } label: {
                                Label("Chapter +1", systemImage: "book.pages")
                            }
                            .tint(.orange)
                            .isVisible(
                                media.node.isMangaOrAnime == .manga &&
                                (
                                    totalChapters == 0 ||
                                    (currentChapter != totalChapters && settingsManager.mangaFormat == .chapter) ||
                                    settingsManager.mangaFormat == .both
                                )
                            )
                                
                            Button {
                                Task {
                                    let current = media.node.getMyListStatus.readVolumes
                                    let total = media.node.volumes
                                    
                                    let updatedVolumeValue = {
                                        if total > 0 {
                                            return min(current + 1, total)
                                        } else {
                                            return current + 1
                                        }
                                    }()
                                    
                                    if updatedVolumeValue > current {
                                        try await mangaController.increaseVolumes(id: media.node.id, volume: updatedVolumeValue)
                                        
                                        toastManager.showUpdatedToast = true
                                        library = try await mangaController.fetchLibrary()
                                    }
                                }
                                
                            } label: {
                                Label("Volume +1", systemImage: "character.book.closed.ja")
                            }
                            .tint(.yellow)
                            .isVisible(
                                media.node.isMangaOrAnime == .manga &&
                                (
                                    totalVolumes == 0 ||
                                    (currentVolume != totalVolumes && settingsManager.mangaFormat == .volume) ||
                                    settingsManager.mangaFormat == .both
                                )
                            )
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            let currentEpisode = media.node.getMyListStatus.watchedEpisodes
                            let totalEpisodes = media.node.episodes
                            
                            Button {
                                Task {
                                    let updatedEpisodeValue = {
                                        if totalEpisodes > 0 {
                                            return min(currentEpisode + 1, totalEpisodes)
                                        } else {
                                            return currentEpisode + 1
                                        }
                                    }()
                                    
                                    if updatedEpisodeValue > currentEpisode {
                                        try await animeController.increaseEpisodes(id: media.node.id, episode: updatedEpisodeValue)
                                        
                                        toastManager.showUpdatedToast = true
                                        library = try await animeController.fetchLibrary()
                                    }
                                }
                            } label: {
                                Label("Episode +1", systemImage: "tv")
                            }
                            .tint(.yellow)
                            .isVisible(
                                media.node.isMangaOrAnime == .anime &&
                                (
                                    totalEpisodes == 0 ||
                                    currentEpisode != totalEpisodes
                                )
                            )
                        }
                        
                    }
                    if displayedLibraryData.isEmpty && !toastManager.isLoading {
                        if searchTerm != "" {
                            ContentUnavailableView.search
                        } else {
                            ContentUnavailableView {
                                Label("No entries found", systemImage: libraryManager.mediaType.icon)
                            } description: {
                                Text("Try a selection a different category.")
                            }
                        }
                    }
                } else {
                    GroupBox {
                        Text("Log in with your MyAnimeList account to be able to edit your library.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    } label: {
                        Label("Info", systemImage: "info.circle")
                            .font(.headline)
                    }
                    .listRowInsets(EdgeInsets())
                    .backgroundStyle(Color(.secondarySystemGroupedBackground))
                }
            }
            .navigationDestination(item: $detailMedia) { media in
                    DetailsView(media: media)
                }
            .safeAreaInset(edge: .top) {
                if tokenHandler.isAuthenticated {
                    PillPicker(
                        options: ProgressStatus.Manga.allCases,
                        selectedOption: $libraryManager.mangaProgressStatus,
                        displayName: { $0.displayName },
                        icon: { AnyView($0.libraryIcon) }
                    )
                    .padding(.bottom, 6)
                    .padding(.top, -4)
                    .background {
                        if #available(iOS 26, *) {
                            EmptyView()
                        } else {
                            Color.clear.background(.ultraThinMaterial)
                        }
                    }
                    .isVisible(libraryManager.mediaType == .manga)
                    
                    PillPicker(
                        options: ProgressStatus.Anime.allCases,
                        selectedOption: $libraryManager.animeProgressStatus,
                        displayName: { $0.displayName },
                        icon: { AnyView($0.libraryIcon) }
                    )
                    .padding(.bottom, 6)
                    .padding(.top, -4)
                    .background {
                        if #available(iOS 26, *) {
                            EmptyView()
                        } else {
                            Color.clear.background(.ultraThinMaterial)
                        }
                    }
                    .isVisible(libraryManager.mediaType == .anime)
                }
            }
            .listStyle(.automatic)
            .listRowSpacing(10)
            .contentMargins(.top, 0)
            .scrollIndicators(.automatic)
            .scrollClipDisabled()
            .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        libraryManager.mediaType = (libraryManager.mediaType == .manga) ? .anime : .manga
                    } label: {
                        Image(systemName: libraryManager.mediaType.icon)
                            .contentTransition(.symbolEffect(.replace))
                            .foregroundColor(.accentColor)
                            .symbolRenderingMode(.monochrome)
                    }
                    .sensoryFeedback(.selection, trigger: libraryManager.mediaType)
                    .buttonStyle(.borderless)
                }
                
                ToolbarItem {
                    Menu {
                        Picker("Sort by", selection: $libraryManager.animeSortOrder) {
                            ForEach(MediaSort.AnimeSort.allCases, id: \.self) { sortOrder in
                                Label(sortOrder.displayName, systemImage: sortOrder.icon)
                                    .tag(sortOrder.rawValue)
                            }
                        }
                        .isVisible(libraryManager.mediaType == .anime)
                        
                        Picker("Sort by", selection: $libraryManager.mangaSortOrder) {
                            ForEach(MediaSort.MangaSort.allCases, id: \.self) { sortOrder in
                                Label(sortOrder.displayName, systemImage: sortOrder.icon)
                                    .tag(sortOrder.rawValue)
                            }
                        }
                        .isVisible(libraryManager.mediaType == .manga)
                    } label: {
                        Image(systemName: libraryManager.mediaType == .anime ? libraryManager.animeSortOrder.icon : libraryManager.mangaSortOrder.icon)
                            .fontWeight(.regular)
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem {
                    Menu {
                        Picker("Order", selection: $libraryManager.sortDirection) {
                            
                            ForEach(SortDirection.allCases, id: \.self) { sortDirection in
                                Label(sortDirection.displayName, systemImage: sortDirection.icon).tag(sortDirection)
                            }
                        }
                    } label: {
                        Image(systemName: libraryManager.sortDirection.icon)
                            .fontWeight(.regular)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationTitle("\(libraryManager.mediaType.displayName) Library")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedMedia, onDismiss: {
                showComments = false
                
                showStartDate = false
                showFinishDate = false
                
                startDate = nil
                finishDate = nil
                
                if let pendingDetailMedia {
                    let mediaToOpen = pendingDetailMedia
                    self.pendingDetailMedia = nil
                    
                    DispatchQueue.main.async {
                        detailMedia = mediaToOpen
                    }
                }
            }) { media in
                NavigationStack {
                    List {
                        Section {
                            Button {
                                pendingDetailMedia = media.node
                                
                                selectedMedia = nil
                            } label: {
                                HStack(spacing: 16) {
                                    AsyncImageView(imageUrl: media.node.mainPicture.largeUrl)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(12)
                                        .overlay(alignment: .topTrailing) {
                                            Image(systemName: "arrow.up.forward.square.fill")
                                                .foregroundStyle(Color.primary)
                                                .padding(6)
                                                .glassEffectOrMaterial()
                                        }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(Color.clear)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        
                        Section {
                            Picker("Progress", selection: $libraryEntry.progressStatus) {
                                ForEach([ProgressStatus.Manga.completed, .reading, .onHold, .dropped, .planToRead], id: \.self) { mangaSelection in
                                    Text(mangaSelection.displayName)
                                        .tag(mangaSelection.rawValue)
                                }
                            }
                            .isVisible(libraryManager.mediaType == .manga)
                            
                            Picker("Progress", selection: $libraryEntry.progressStatus) {
                                ForEach([ProgressStatus.Anime.completed, .watching, .dropped, .onHold, .planToWatch], id: \.self) { animeSelection in
                                    Text(animeSelection.displayName)
                                        .tag(animeSelection.rawValue)
                                }
                            }
                            .isVisible(libraryManager.mediaType == .anime)
                            
                            Picker("Rating", selection: $libraryEntry.score) {
                                ForEach(0...10, id: \.self) { rating in
                                    if let ratingValue = RatingValues(rawValue: rating) {
                                        Text(ratingValue.displayName).tag(rating)
                                    }
                                }
                            }
                            
                            Group {
                                Picker(selection: $libraryEntry.readChapters, label:
                                            VStack(alignment: .leading, spacing: 4) {
                                        Text("Chapter")
                                        Text(verbatim: "\(libraryEntry.readChapters)/\(media.node.chapters)")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    ) {
                                        ForEach(0...media.node.chapters, id: \.self) { chapter in
                                            Text(chapter, format: .number).tag(chapter)
                                        }
                                    }
                                    .isVisible(media.node.chapters != 0 && (settingsManager.mangaFormat == .chapter || settingsManager.mangaFormat == .both))
                                
                                LabeledContent("Chapter") {
                                    HStack(spacing: 0) {
                                        Button {
                                            libraryEntry.readChapters -= 1
                                        } label: {
                                            Image(systemName: "minus")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .buttonStyle(.plain)
                                        .disabled(libraryEntry.readChapters == 0)

                                        Divider()

                                        TextField("Chapter", value: $libraryEntry.readChapters, format: .number)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                                        Divider()

                                        Button {
                                            libraryEntry.readChapters += 1
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
                                    media.node.chapters == 0 &&
                                    (settingsManager.mangaFormat == .chapter || settingsManager.mangaFormat == .both)
                                )
                                
                                Picker(selection: $libraryEntry.readVolumes, label:
                                        VStack(alignment: .leading, spacing: 4) {
                                    Text("Volume")
                                    Text(verbatim: "\(libraryEntry.readVolumes)/\(media.node.volumes)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                ) {
                                    ForEach(0...media.node.volumes, id: \.self) { volume in
                                        Text(volume, format: .number).tag(volume)
                                    }
                                }
                                .isVisible(media.node.volumes != 0 && (settingsManager.mangaFormat == .volume || settingsManager.mangaFormat == .both))
                              
                                
                                LabeledContent("Volume") {
                                    HStack(spacing: 0) {
                                        Button {
                                            libraryEntry.readVolumes -= 1
                                        } label: {
                                            Image(systemName: "minus")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                        .buttonStyle(.plain)
                                        .disabled(libraryEntry.readVolumes == 0)

                                        Divider()

                                        TextField("Volume", value: $libraryEntry.readVolumes, format: .number)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                                        Divider()

                                        Button {
                                            libraryEntry.readVolumes += 1
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
                                    media.node.volumes == 0 &&
                                    (settingsManager.mangaFormat == .volume || settingsManager.mangaFormat == .both)
                                )
                            }
                            .isVisible(media.node.isMangaOrAnime == .manga)
                                
                            Picker(selection: $libraryEntry.watchedEpisodes, label:
                                    VStack(alignment: .leading, spacing: 4) {
                                Text("Episode")
                                Text(verbatim: "\(libraryEntry.watchedEpisodes)/\(media.node.episodes)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            ) {
                                ForEach(0...media.node.episodes, id: \.self) { episode in
                                    Text(episode, format: .number).tag(episode)
                                }
                            }
                            .isVisible(media.node.isMangaOrAnime == .anime && media.node.episodes != 0)
                        
                            LabeledContent("Episode") {
                                HStack(spacing: 0) {
                                    Button {
                                        libraryEntry.watchedEpisodes -= 1
                                    } label: {
                                        Image(systemName: "minus")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(libraryEntry.watchedEpisodes == 0)

                                    Divider()

                                    TextField("Episode", value: $libraryEntry.watchedEpisodes, format: .number)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .labelsHidden()

                                    Divider()

                                    Button {
                                        libraryEntry.watchedEpisodes += 1
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
                            .isVisible(media.node.episodes == 0 && media.node.isMangaOrAnime == .anime)
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                    Text("Priority")

                                    Picker("Priority", selection: $libraryEntry.priority) {
                                        ForEach(PriorityValues.allCases, id: \.self) { priority in
                                            Text(priority.displayName)
                                                .tag(priority.rawValue)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    .labelsHidden()
                                }
                        }
                        .isVisible(settingsManager.advancedMode)
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    showComments.toggle()
                                    if !showComments {
                                        if libraryManager.mediaType == .anime {
                                            libraryEntry.userComments = ""
                                        } else {
                                            libraryEntry.userComments = ""
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
                                        .foregroundStyle(showComments ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if showComments {
                                if (libraryManager.mediaType == .anime) {
                                    TextField("Comments", text: $libraryEntry.userComments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                } else {
                                    TextField("Comments", text: $libraryEntry.userComments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        .isVisible(settingsManager.advancedMode)
                        
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
                                        .foregroundStyle(showStartDate ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
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
                                        .foregroundStyle(showFinishDate ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
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
                        .isVisible(settingsManager.advancedMode)
                    }
                    .scrollContentBackground(.hidden)
                    .contentMargins(.top, 0)
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            if #available(iOS 26, *) {
                                Button(role: .confirm) {
                                    saveEntry(media.node.id)
                                }
                                .tint(Color.getByColorString(settingsManager.accentColor.rawValue))
                                
                            } else {
                                Button("Save") {
                                    saveEntry(media.node.id)
                                }
                                .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
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
                            .alert("Remove entry", isPresented: $showAlert) {
                                Button("Yes", role: .destructive) {
                                    deleteEntry(media.node.id)
                                }
                                Button("No", role: .cancel) {}
                            } message: {
                                Text("Are you sure you want to remove \(media.node.preferredTitle) from your library?")
                            }
                        }
                        
                    }
                    .navigationTitle(media.node.preferredTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([settingsManager.advancedMode ? .fraction(0.8) : .medium])
                    .presentationBackgroundInteraction(.disabled)
                    .presentationBackground(.regularMaterial)
                    .onAppear {
                        loadingMediaID = nil
                    }
                }
            }
            
        }
        .sheet(isPresented: $showNotificationSetupSheet) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 38, weight: .medium))
                        .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
                        .frame(width: 84, height: 84)
                        .background {
                            Circle()
                                .fill(Color.getByColorString(settingsManager.accentColor.rawValue).opacity(0.12))
                        }

                    VStack(spacing: 8) {
                        Text("Episode Notifications")
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)

                        Text("Get notified when new episodes of anime you're watching are out.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 18)

                    VStack(spacing: 22) {
                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "timer")
                                .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 44, height: 44)
                                .background {
                                    RoundedRectangle(
                                        cornerRadius: 12,
                                        style: .continuous
                                    )
                                    .fill(Color.getByColorString(settingsManager.accentColor.rawValue).opacity(0.12))
                                }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Choose When to Be Notified")
                                    .font(.body.weight(.semibold))

                                Text("Get notified when an episode is out, 15 minutes before, 1 hour before, or earlier that day.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)
                        }

                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "bookmark.fill")
                                .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 44, height: 44)
                                .background {
                                    RoundedRectangle(
                                        cornerRadius: 12,
                                        style: .continuous
                                    )
                                    .fill(Color.getByColorString(settingsManager.accentColor.rawValue).opacity(0.12))
                                }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Only for Anime You Watch")
                                    .font(.body.weight(.semibold))

                                Text("Notifications are only scheduled for currently airing anime in your library.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)
                        }

                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 44, height: 44)
                                .background {
                                    RoundedRectangle(
                                        cornerRadius: 12,
                                        style: .continuous
                                    )
                                    .fill(Color.getByColorString(settingsManager.accentColor.rawValue).opacity(0.12))
                                }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Adjust It Anytime")
                                    .font(.body.weight(.semibold))

                                Text("You can adjust the timing or turn off notifications anytime under Settings > Episode Notifications.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 0)
                        }
                    }
                    .padding(.top, 30)
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)

                Spacer(minLength: 20)

                VStack(spacing: 8) {
                    Button {
                        Task { @MainActor in
                            do {
                                let granted = try await AnimeNotificationManager
                                    .requestPermission()

                                guard granted else {
                                    settingsManager.airingNotificationsEnabled = false
                                    return
                                }

                                let schedules = try modelContext.fetch(
                                    FetchDescriptor<AnimeSchedule>()
                                )

                                try await AnimeNotificationManager
                                    .scheduleNotifications(
                                        for: schedules,
                                        notificationTime: settingsManager.airingNotificationTiming,
                                        timeFormat: settingsManager.airingNotificationTimeFormat
                                    )

                                settingsManager.airingNotificationsEnabled = true
                                isNoticationSetupDismissed = true
                                showNotificationSetupSheet = false
                            } catch {
                                settingsManager.airingNotificationsEnabled = false
                                isNoticationSetupDismissed = false

                                print(
                                    "Notification setup failed:",
                                    error
                                )
                            }
                        }
                    } label: {
                        Text("Set Up Notifications")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 14))

                    Button("Maybe Later") {
                        isNoticationSetupDismissed = true
                        showNotificationSetupSheet = false
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .tint(Color.getByColorString(settingsManager.accentColor.rawValue))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .presentationDetents([.fraction(0.8)])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled()
        }
        .safeAreaInset(edge: .bottom) {
            if !isNoticationSetupDismissed && libraryManager.mediaType == .anime {
                Button {
                    showNotificationSetupSheet = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.tint)
                            .frame(width: 36, height: 36)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.accentColor.opacity(0.15))
                            }

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Set Up Episode Notifications")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)

                            Text("Get notified when new episodes are out.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer(minLength: 8)

                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.accentColor.opacity(0.10))
                            }
                    }
                    .contentShape(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 10)
                .padding(.bottom, 8)
            }
        }
        .onAppear {
            fetchLibrary()
        }
        .onChange(of: libraryManager.needToLoadData) {
            fetchLibrary()
        }
        .onChange(of: selectedMedia) {
            if (selectedMedia != nil) {
                    
                guard let media = selectedMedia else { return }
                libraryEntry = media.node.getMyListStatus
                 
                if libraryEntry.userComments != "" {
                    showComments = true
                }
                
                if libraryEntry.startDateValue != "" {
                    showStartDate = true
                    startDate = Date.from(libraryEntry.startDateValue)
                }
                if libraryEntry.finishDateValue != "" {
                    showFinishDate = true
                    finishDate = Date.from(libraryEntry.finishDateValue)
                }
            }
        }
    }
    
    private func fetchLibrary() {
        guard tokenHandler.isAuthenticated else { return }

        Task {
            toastManager.isLoading = true

            defer {
                toastManager.isLoading = false
            }

            do {
                switch libraryManager.mediaType {
                case .manga:
                    library = try await mangaController.fetchLibrary()

                case .anime:
                    let fetchedLibrary = try await animeController.fetchLibrary()

                    let malIds = fetchedLibrary.data
                        .filter {
                            $0.node.specificStatus == .anime(.currentlyAiring)
                        }
                        .map(\.node.id)

                    if !malIds.isEmpty {
                        do {
                            let scheduleCount = try modelContext.fetchCount(
                                FetchDescriptor<AnimeSchedule>()
                            )

                            if scheduleCount == 0 || shouldRefreshAnimeSchedule {
                                let airingAnime = try await aniListController
                                    .fetchAiringAnime(malIds: malIds)

                                let syncedSchedules = try syncAnimeSchedule(
                                    with: airingAnime
                                )

                                if settingsManager.airingNotificationsEnabled {
                                    try await AnimeNotificationManager
                                        .scheduleNotifications(
                                            for: syncedSchedules,
                                            notificationTime: settingsManager.airingNotificationTiming,
                                            timeFormat: settingsManager.airingNotificationTimeFormat
                                        )
                                }

                                animeScheduleLastRefresh =
                                    Date.now.timeIntervalSince1970
                            }
                        } catch {
                            print(
                                "Failed to sync anime schedules:",
                                error
                            )
                        }
                    }

                    library = fetchedLibrary
                }
            } catch {
                print("Failed to load library:", error)
            }
        }
    }
    
    private func syncAnimeSchedule(with response: AiringResponse) throws -> [AnimeSchedule] {
        guard let mediaList = response.data?.page.media else {
            return []
        }

        let existingSchedules = try modelContext.fetch(
            FetchDescriptor<AnimeSchedule>()
        )

        let schedulesByMalId = Dictionary(
            uniqueKeysWithValues: existingSchedules.map {
                ($0.malId, $0)
            }
        )

        var syncedSchedules: [AnimeSchedule] = []

        for anime in mediaList {
            guard
                let malId = anime.idMal,
                let nextEpisode = anime.nextAiringEpisode
            else {
                continue
            }

            let schedule: AnimeSchedule

            if let existingSchedule = schedulesByMalId[malId] {
                existingSchedule.englishTitle = anime.title.english
                existingSchedule.romajiTitle = anime.title.romaji
                existingSchedule.nativeTitle = anime.title.native
                existingSchedule.episodeNumber = nextEpisode.episode
                existingSchedule.airingAt = nextEpisode.airingDate

                schedule = existingSchedule
            } else {
                schedule = AnimeSchedule(
                    malId: malId,
                    englishTitle: anime.title.english,
                    romajiTitle: anime.title.romaji,
                    nativeTitle: anime.title.native,
                    episodeNumber: nextEpisode.episode,
                    airingAt: nextEpisode.airingDate
                )

                modelContext.insert(schedule)
            }

            syncedSchedules.append(schedule)
        }

        if modelContext.hasChanges {
            try modelContext.save()
        }

        return syncedSchedules
    }
    
    private var shouldRefreshAnimeSchedule: Bool {
        guard animeScheduleLastRefresh > 0 else {
            return true
        }

        let lastRefresh = Date(
            timeIntervalSince1970: animeScheduleLastRefresh
        )

        let refreshInterval: TimeInterval = 6 * 60 * 60

        return Date.now.timeIntervalSince(lastRefresh) >= refreshInterval
    }
    
    var saveEntry: (Int) -> Void {
        return { id in
            Task {
                if libraryManager.mediaType == .manga {
                    
                    try await mangaController.saveProgress(id: id, status: libraryEntry.progressStatus, score: libraryEntry.score, chapters: libraryEntry.readChapters, volumes: libraryEntry.readVolumes, comments: libraryEntry.userComments, startDate: startDate, finishDate: finishDate)
                    
                    toastManager.showUpdatedToast = true
                    library = try await mangaController.fetchLibrary()
                } else if libraryManager.mediaType == .anime {
                    
                    try await animeController.saveProgress(id: id, status: libraryEntry.progressStatus, score: libraryEntry.score, episodes: libraryEntry.watchedEpisodes, comments: libraryEntry.userComments, startDate: startDate, finishDate: finishDate)
                    toastManager.showUpdatedToast = true
                    
                    library = try await animeController.fetchLibrary()
                }
                loadingMediaID = nil
                selectedMedia = nil
                
            }
        }
    }
    
    var deleteEntry: (Int) -> Void {
        return { id in
            Task {
                if(libraryManager.mediaType == .manga) {
                    try await mangaController.deleteEntry(id: id)
                    toastManager.showRemovedToast = true
                    library = try await mangaController.fetchLibrary()
                }
                if(libraryManager.mediaType == .anime) {
                    try await animeController.deleteEntry(id: id)
                    toastManager.showRemovedToast = true
                    library = try await animeController.fetchLibrary()
                }
                
                showAlert = false
                selectedMedia = nil
                loadingMediaID = nil
            }
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(ToastManager.shared)
}
