import SwiftUI

struct LibraryView: View {
    
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
    
    @StateObject private var libraryManager: LibraryManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    @State private var detailMedia: MediaNode?
    @State private var pendingDetailMedia: MediaNode?
    
    
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
                                    
                                    alertManager.showUpdatedAlert = true
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
                                    
                                    alertManager.showUpdatedAlert = true
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
                                        
                                        alertManager.showUpdatedAlert = true
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
                                        
                                        alertManager.showUpdatedAlert = true
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
                                        
                                        alertManager.showUpdatedAlert = true
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
                    if displayedLibraryData.isEmpty && !alertManager.isLoading {
                        if searchTerm != "" {
                            ContentUnavailableView.search
                        } else {
                            ContentUnavailableView {
                                Label("No entries found", systemImage: libraryManager.mediaType.icon)
                            } description: {
                                Text("Try a different category.")
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
            .navigationTitle("\(libraryManager.mediaType.rawValue.capitalized) Library")
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
                                        Text("\(libraryEntry.readChapters)/\(media.node.chapters)")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    ) {
                                        ForEach(0...media.node.chapters, id: \.self) { chapter in
                                            Text("\(chapter)").tag(chapter)
                                        }
                                    }
                                    .isVisible(media.node.chapters != 0 && (settingsManager.mangaFormat == .chapter || settingsManager.mangaFormat == .both))
                                
                                LabeledContent("Chapters") {
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

                                        TextField("", value: $libraryEntry.readChapters, format: .number)
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
                                    Text("\(libraryEntry.readVolumes)/\(media.node.volumes)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                ) {
                                    ForEach(0...media.node.volumes, id: \.self) { volume in
                                        Text("\(volume)").tag(volume)
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

                                        TextField("", value: $libraryEntry.readVolumes, format: .number)
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
                                Text("\(libraryEntry.watchedEpisodes)/\(media.node.episodes)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            ) {
                                ForEach(0...media.node.episodes, id: \.self) { episode in
                                    Text("\(episode)").tag(episode)
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

                                    TextField("", value: $libraryEntry.watchedEpisodes, format: .number)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

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

                                    Picker("", selection: $libraryEntry.priority) {
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
                                    "Finish date",
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
                if  libraryEntry.startDateValue != "" {
                    showFinishDate = true
                    finishDate = Date.from(libraryEntry.finishDateValue)
                }
            }
        }
    }
    
    private func fetchLibrary() {
        if (tokenHandler.isAuthenticated) {
            Task {
                alertManager.isLoading = true
                
                do {
                    if libraryManager.mediaType == .manga {
                        library = try await mangaController.fetchLibrary()
                    } else if libraryManager.mediaType == .anime {
                        library = try await animeController.fetchLibrary()
                    }
                }
                
                alertManager.isLoading = false
            }
        }
    }
    
    var saveEntry: (Int) -> Void {
        return { id in
            Task {
                if libraryManager.mediaType == .manga {
                    
                    try await mangaController.saveProgress(id: id, status: libraryEntry.progressStatus, score: libraryEntry.score, chapters: libraryEntry.readChapters, volumes: libraryEntry.readVolumes, comments: libraryEntry.userComments, startDate: startDate, finishDate: finishDate)
                    
                    alertManager.showUpdatedAlert = true
                    library = try await mangaController.fetchLibrary()
                } else if libraryManager.mediaType == .anime {
                    
                    try await animeController.saveProgress(id: id, status: libraryEntry.progressStatus, score: libraryEntry.score, episodes: libraryEntry.watchedEpisodes, comments: libraryEntry.userComments, startDate: startDate, finishDate: finishDate)
                    alertManager.showUpdatedAlert = true
                    
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
                    alertManager.showRemovedAlert = true
                    library = try await mangaController.fetchLibrary()
                }
                if(libraryManager.mediaType == .anime) {
                    try await animeController.deleteEntry(id: id)
                    alertManager.showRemovedAlert = true
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
        .environmentObject(AlertManager.shared)
}
