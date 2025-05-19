import SwiftUI

struct LibraryView: View {
    
    struct MangaEntry {
        var progressStatus: ProgressStatus.Manga
        var score: Int
        var currentVolume: Int
        var totalVolumes: Int
        var currentChapter: Int
        var totalChapters: Int
        var comments: String
        var startDate: String
        var finishDate: String
    }
    
    struct AnimeEntry {
        var progressStatus: ProgressStatus.Anime
        var score: Int
        var currentEpisode: Int
        var totalEpisodes: Int
        var comments: String
        var startDate: String
        var finishDate: String
    }
    
    @State private var libraryResponse = LibraryResponse(data: [])
    
    @State private var selectedMedia: MediaNode?
    
    @State private var mangaEntry = MangaEntry(
        progressStatus: .reading,
        score: 0,
        currentVolume: 0,
        totalVolumes: 0,
        currentChapter: 0,
        totalChapters: 0,
        comments: "",
        startDate: "",
        finishDate: ""
    )
    @State private var animeEntry = AnimeEntry(
        progressStatus: .watching,
        score: 0,
        currentEpisode: 0,
        totalEpisodes: 0,
        comments: "",
        startDate: "",
        finishDate: ""
    )
    
    @State private var showAlert = false
    @State private var searchTerm = ""
    
    @State private var mangaMode = "all"
    
    @State private var showComments = false

    
    @State private var showDates = false
    
    @State private var setStartDate = false
    @State private var startDate: Date?

    @State private var endDate: Date?
    @State private var setEntDate = false
    
    @State private var loadingMediaID: Int?
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    
    @StateObject private var libraryManager: LibraryManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    
    private var filteredLibraryData: [MediaNode] {
        if searchTerm.isEmpty {
            return libraryResponse.data
        } else {
            return libraryResponse.data.filter { media in
                media.node.getTitle.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack {
                        if tokenHandler.isAuthenticated {
                            if libraryManager.mediaType == .manga {
                                PillPicker(
                                    options: ProgressStatus.Manga.allCases,
                                    selectedOption: $libraryManager.mangaProgressStatus,
                                    displayName: { $0.displayName },
                                    icon: { AnyView($0.libraryIcon) }
                                )
                                ForEach(filteredLibraryData, id: \ .self) { manga in
                                    Button(action: {
                                        selectedMedia = manga
                                        loadingMediaID = manga.node.id
                                    }) {
                                        LibraryMediaView(
                                            title: manga.node.getTitle,
                                            image: manga.node.getCover,
                                            releaseYear: manga.node.getReleaseYear,
                                            type: manga.node.getType,
                                            rating: manga.node.getListStatus.getRating,
                                            completedUnits: manga.node.getListStatus.getReadChapters,
                                            totalUnits: manga.node.getChapters
                                        ).overlay(
                                            Group {
                                                if loadingMediaID == manga.node.id {
                                                    ProgressView()
                                                        .progressViewStyle(CircularProgressViewStyle())
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                        .background(Color.black.opacity(0.4))
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                } else {
                                                    EmptyView()
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            if libraryManager.mediaType == .anime {
                                PillPicker(
                                    options: ProgressStatus.Anime.allCases,
                                    selectedOption: $libraryManager.animeProgressStatus,
                                    displayName: { $0.displayName },
                                    icon: { AnyView($0.libraryIcon) },
                                )
                                ForEach(filteredLibraryData, id: \ .self) { anime in
                                    Button(action: {
                                        selectedMedia = anime
                                        loadingMediaID = anime.node.id
                                    }) {
                                        LibraryMediaView(
                                            title: anime.node.getTitle,
                                            image: anime.node.getCover,
                                            releaseYear: anime.node.getReleaseYear,
                                            type: anime.node.getType,
                                            rating: anime.node.getListStatus.getRating,
                                            completedUnits: anime.node.getListStatus.getWatchedEpisodes,
                                            totalUnits: anime.node.getEpisodes
                                        )
                                        .overlay(
                                            Group {
                                                if loadingMediaID == anime.node.id {
                                                    ProgressView()
                                                        .progressViewStyle(CircularProgressViewStyle())
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                        .background(Color.black.opacity(0.4))
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                } else {
                                                    EmptyView()
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                            if filteredLibraryData.isEmpty && !alertManager.isLoading {
                                if searchTerm != "" {
                                    ContentUnavailableView.search
                                } else {
                                    if (libraryManager.mediaType == .manga) {
                                        ContentUnavailableView {
                                            Label("No \(libraryManager.mangaProgressStatus.displayName) mangas found", systemImage: "character.book.closed.ja")
                                        } description: {
                                            Text("Try a different filter category.")
                                        }
                                    } else {
                                        ContentUnavailableView {
                                            Label("No \(libraryManager.animeProgressStatus.displayName) animes found", systemImage: "play.tv")
                                        } description: {
                                            Text("Try a different filter category.")
                                        }
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
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        libraryManager.mediaType = (libraryManager.mediaType == .manga) ? .anime : .manga
                    } label: {
                        Image(systemName: libraryManager.mediaType == .manga ? "book" : "tv")
                            .contentTransition(.symbolEffect(.replace))
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                            .symbolRenderingMode(.monochrome)
                    }
                    .sensoryFeedback(.selection, trigger: libraryManager.mediaType)
                    .buttonStyle(.borderless)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Text("Sort by")
                        if libraryManager.mediaType == .anime {
                            Picker("Sort by", selection: $libraryManager.animeSortOrder) {
                                ForEach(LibraryAnimeSort.allCases, id: \ .self) { sortSelection in
                                    Text(sortSelection.displayName).tag(sortSelection.rawValue)
                                }
                            }
                        } else {
                            Picker("Sort by", selection: $libraryManager.mangaSortOrder) {
                                ForEach(LibraryMangaSort.allCases, id: \ .self) { sortSelection in
                                    Text(sortSelection.displayName).tag(sortSelection.rawValue)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .navigationTitle("\(libraryManager.mediaType.rawValue.capitalized) library")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .sheet(item: $selectedMedia, onDismiss: {
                showComments = false
                
                showDates = false
                
                startDate = nil
                endDate = nil
            }) { media in
                NavigationStack {
                    List {
                        Section {
                            AsyncImageView(imageUrl: media.node.getCover)
                                .frame(width: 146, height: 230)
                                .cornerRadius(12)
                                .listRowBackground(Color.clear)
                        }
                        .listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 16,
                            bottom: 0,
                            trailing: 16
                        ))
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Section {
                            if (libraryManager.mediaType == .manga) {
                                Picker("Progress", selection: $mangaEntry.progressStatus) {
                                    ForEach([ProgressStatus.Manga.completed, .reading, .onHold, .dropped, .planToRead], id: \.self) { mangaSelection in
                                        Text(mangaSelection.displayName).tag(mangaSelection)
                                    }
                                }
                                .onChange(of: mangaEntry.progressStatus) {
                                    if mangaEntry.progressStatus == .completed {
                                        if mangaEntry.totalVolumes != 0 {
                                            mangaEntry.currentVolume = mangaEntry.totalVolumes
                                        }
                                        if mangaEntry.totalChapters != 0 {
                                            mangaEntry.currentChapter = mangaEntry.totalChapters
                                        }
                                    }
                                }
                                
                                Picker("Rating", selection: $mangaEntry.score) {
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
                                    
                                    Picker("", selection: $mangaMode) {
                                        Text("All").tag("all")
                                        Text("Chapter").tag("chapters")
                                        Text("Volume").tag("volumes")
                                    }
                                    .pickerStyle(.segmented)
                                }
                                
                                if (mangaMode == "all") {
                                    if mangaEntry.totalChapters != 0 {
                                        HStack {
                                            Text("Chapter")
                                                .foregroundStyle(Color.primary)
                                            Spacer()
                                            Menu {
                                                ForEach(0...mangaEntry.totalChapters, id: \.self) { chapter in
                                                    Button("\(chapter)") {
                                                        mangaEntry.currentChapter = chapter
                                                    }
                                                }
                                            } label: {
                                                HStack(spacing: 4) {
                                                    Text("\(mangaEntry.currentChapter)/\(mangaEntry.totalChapters)")
                                                        .foregroundColor(.secondary)
                                                    Image(systemName: "chevron.up.chevron.down")
                                                        .imageScale(.small)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .onChange(of: mangaEntry.currentChapter) {
                                                if mangaEntry.totalChapters == mangaEntry.currentChapter {
                                                    mangaEntry.progressStatus = .completed
                                                }
                                                if mangaEntry.totalVolumes != 0 {
                                                    mangaEntry.currentVolume = mangaEntry.totalVolumes
                                                }
                                            }
                                        }
                                    } else {
                                        Stepper("Chapter \(mangaEntry.currentChapter)/?", value: $mangaEntry.currentChapter, in: 0...Int.max)
                                    }
                                    if mangaEntry.totalVolumes != 0 {
                                        HStack {
                                            Text("Volume")
                                                .foregroundStyle(Color.primary)
                                            Spacer()
                                            Menu {
                                                ForEach(0...mangaEntry.totalVolumes, id: \.self) { volume in
                                                    Button("\(volume)") {
                                                        mangaEntry.currentVolume = volume
                                                    }
                                                }
                                            } label: {
                                                HStack(spacing: 4) {
                                                    Text("\(mangaEntry.currentVolume)/\(mangaEntry.totalVolumes)")
                                                        .foregroundColor(.secondary)
                                                    Image(systemName: "chevron.up.chevron.down")
                                                        .imageScale(.small)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .onChange(of: mangaEntry.currentVolume) {
                                                if mangaEntry.totalVolumes == mangaEntry.currentVolume {
                                                    mangaEntry.progressStatus = .completed
                                                }
                                                if mangaEntry.totalChapters != 0 {
                                                    mangaEntry.currentChapter = mangaEntry.totalChapters
                                                }
                                            }
                                        }
                                    } else {
                                        Stepper("Volume \(mangaEntry.currentVolume)/?", value: $mangaEntry.currentVolume, in: 0...Int.max)
                                    }
                                }
                                
                                if (mangaMode == "chapters") {
                                    if mangaEntry.totalChapters != 0 {
                                        HStack {
                                            Text("Chapter")
                                                .foregroundStyle(Color.primary)
                                            Spacer()
                                            Menu {
                                                ForEach(0...mangaEntry.totalChapters, id: \.self) { chapter in
                                                    Button("\(chapter)") {
                                                        mangaEntry.currentChapter = chapter
                                                    }
                                                }
                                            } label: {
                                                HStack(spacing: 4) {
                                                    Text("\(mangaEntry.currentChapter)/\(mangaEntry.totalChapters)")
                                                        .foregroundColor(.secondary)
                                                    Image(systemName: "chevron.up.chevron.down")
                                                        .imageScale(.small)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .onChange(of: mangaEntry.currentChapter) {
                                                if mangaEntry.totalChapters == mangaEntry.currentChapter {
                                                    mangaEntry.progressStatus = .completed
                                                }
                                                if mangaEntry.totalVolumes != 0 {
                                                    mangaEntry.currentChapter = mangaEntry.totalChapters
                                                }
                                            }
                                        }
                                    } else {
                                        Stepper("Chapter \(mangaEntry.currentChapter)/?", value: $mangaEntry.currentChapter, in: 0...Int.max)
                                    }
                                }
                                if (mangaMode == "volumes") {
                                    if mangaEntry.totalVolumes != 0 {
                                        HStack {
                                            Text("Volume")
                                                .foregroundStyle(Color.primary)
                                            Spacer()
                                            Menu {
                                                ForEach(0...mangaEntry.totalVolumes, id: \.self) { volume in
                                                    Button("\(volume)") {
                                                        mangaEntry.currentVolume = volume
                                                    }
                                                }
                                            } label: {
                                                HStack(spacing: 4) {
                                                    Text("\(mangaEntry.currentVolume)/\(mangaEntry.totalVolumes)")
                                                        .foregroundColor(.secondary)
                                                    Image(systemName: "chevron.up.chevron.down")
                                                        .imageScale(.small)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .onChange(of: mangaEntry.currentVolume) {
                                                if mangaEntry.totalVolumes == mangaEntry.currentVolume {
                                                    mangaEntry.progressStatus = .completed
                                                }
                                                if mangaEntry.totalChapters != 0 {
                                                    mangaEntry.currentVolume = mangaEntry.totalVolumes
                                                }
                                            }
                                        }
                                    } else {
                                        Stepper("Volume \(mangaEntry.currentVolume)/?", value: $mangaEntry.currentVolume, in: 0...Int.max)
                                    }
                                }
                                
                            }
                            
                            if (libraryManager.mediaType == .anime){
                                Picker("Status", selection: $animeEntry.progressStatus) {
                                    ForEach([ProgressStatus.Anime.completed, .watching, .dropped, .onHold, .planToWatch], id: \.self) { animeSelection in
                                        Text(animeSelection.displayName).tag(animeSelection)
                                    }
                                }
                                .onChange(of: animeEntry.progressStatus) {
                                    if animeEntry.progressStatus == .completed {
                                        if animeEntry.totalEpisodes != 0 {
                                            animeEntry.currentEpisode = animeEntry.totalEpisodes
                                        }
                                    }
                                }
                                
                                Picker("Rating", selection: $animeEntry.score) {
                                    ForEach(0...10, id: \.self) { rating in
                                        if let ratingValue = RatingValues(rawValue: rating) {
                                            Text(ratingValue.displayName).tag(rating)
                                        } else {
                                            Text("Unknown")
                                        }
                                    }
                                }
                                
                                if animeEntry.totalEpisodes != 0 {
                                    HStack {
                                        Text("Episode")
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                        Menu {
                                            ForEach(0...animeEntry.totalEpisodes, id: \.self) { episode in
                                                Button("\(episode)") {
                                                    animeEntry.currentEpisode = episode
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 4) {
                                                Text("\(animeEntry.currentEpisode)/\(animeEntry.totalEpisodes)")
                                                    .foregroundColor(.secondary)
                                                Image(systemName: "chevron.up.chevron.down")
                                                    .imageScale(.small)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .onChange(of: animeEntry.currentEpisode) {
                                            if animeEntry.totalEpisodes != 0 {
                                                if animeEntry.currentEpisode == animeEntry.totalEpisodes {
                                                    animeEntry.progressStatus = .completed
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Stepper("Episode \(animeEntry.currentEpisode)/?", value: $animeEntry.currentEpisode, in: 0...Int.max)
                                }
                            }
                        }
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    showComments.toggle()
                                    if !showComments {
                                        if libraryManager.mediaType == .anime {
                                            animeEntry.comments = ""
                                        } else {
                                            mangaEntry.comments = ""
                                        }
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
                                if (libraryManager.mediaType == .anime) {
                                    TextField("Comments", text: $animeEntry.comments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                } else {
                                    TextField("Comments", text: $mangaEntry.comments)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        
                        Section {
                            Button(action: {
                                withAnimation {
                                    showDates.toggle()
                                    if !showDates {
                                        startDate = nil
                                        endDate = nil
                                    }
                                }
                            }) {
                                Label {
                                    Text(showDates ? "Remove dates" : "Add dates")
                                } icon: {
                                    Image(systemName: showDates ? "calendar.badge.minus" : "calendar.badge.plus")
                                        .foregroundStyle(showDates ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if showDates {
                                VStack {
                                    DatePicker(
                                        "Startdate",
                                        selection: Binding(
                                            get: { startDate ?? Date() },
                                            set: { startDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                    DatePicker(
                                        "Enddate",
                                        selection: Binding(
                                            get: { endDate ?? Date() },
                                            set: { endDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                }
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .scrollBounceBehavior(.basedOnSize)
                    .padding(.horizontal)
                    .padding(.top, -35)
                    .scrollIndicators(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Save") {
                                Task {
                                    if (libraryManager.mediaType == .manga) {
                                        try await mangaController.saveProgress(
                                            id: media.node.id,
                                            status: mangaEntry.progressStatus.rawValue,
                                            score: mangaEntry.score,
                                            chapters: mangaEntry.currentChapter,
                                            volumes: mangaEntry.currentVolume,
                                            comments: mangaEntry.comments,
                                            startDate: startDate,
                                            finishDate: endDate
                                        )
                                        alertManager.showUpdatedAlert = true
                                        libraryResponse = try await mangaController.fetchLibrary()
                                    }
                                    if (libraryManager.mediaType == .anime) {
                                        try await animeController.saveProgress(
                                            id: media.node.id,
                                            status: animeEntry.progressStatus.rawValue,
                                            score: animeEntry.score,
                                            episodes: animeEntry.currentEpisode,
                                            comments: animeEntry.comments,
                                            startDate: startDate,
                                            finishDate: endDate
                                        )
                                        alertManager.showUpdatedAlert = true
                                        libraryResponse = try await animeController.fetchLibrary()
                                        
                                    }
                                    loadingMediaID = nil
                                    selectedMedia = nil
                                }
                            }
                            .foregroundStyle(Color.getByColorString(settingsManager.accentColor.rawValue))
                        }
                        ToolbarItem(placement: .principal) {
                            Text(media.node.getTitle)
                                .lineLimit(1)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: {
                                showAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .symbolRenderingMode(.palette)
                                    .foregroundColor(.red)
                            }
                            .alert("Remove entry", isPresented: $showAlert) {
                                Button("Delete", role: .destructive) {
                                    Task {
                                        if(libraryManager.mediaType == .manga) {
                                            try await mangaController.deleteEntry(id: media.node.id)
                                            alertManager.showRemovedAlert = true
                                            libraryResponse = try await mangaController.fetchLibrary()
                                        }
                                        if(libraryManager.mediaType == .anime) {
                                            try await animeController.deleteEntry(id: media.node.id)
                                            alertManager.showRemovedAlert = true
                                            libraryResponse = try await animeController.fetchLibrary()
                                        }
                                        showAlert = false
                                        selectedMedia = nil
                                        loadingMediaID = nil
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("Are you sure you want to remove \(media.node.getTitle) from your library?")
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationDetents([.fraction(0.8)])
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
                if (libraryManager.mediaType == .manga) {
                    mangaEntry = MangaEntry(
                        progressStatus: ProgressStatus.Manga(rawValue: selectedMedia?.node.listStatus?.status ?? "") ?? .reading,
                        score: selectedMedia?.node.listStatus?.rating ?? 0,
                        currentVolume: selectedMedia?.node.listStatus?.readVolumes ?? 0,
                        totalVolumes: selectedMedia?.node.numberOfVolumes ?? 0,
                        currentChapter: selectedMedia?.node.listStatus?.readChapters ?? 0,
                        totalChapters: selectedMedia?.node.numberOfChapters ?? 0,
                        comments: selectedMedia?.node.listStatus?.comments ?? "",
                        startDate: selectedMedia?.node.listStatus?.startDate ?? "",
                        finishDate: selectedMedia?.node.listStatus?.finishDate ?? ""
                    )
                    if mangaEntry.comments != "" {
                        showComments = true
                    }
                    
                    if mangaEntry.startDate != "" || mangaEntry.finishDate != "" {
                        showDates = true
                        startDate = stringToDate(mangaEntry.startDate)
                        endDate = stringToDate(mangaEntry.finishDate)
                    }
                }
                if (libraryManager.mediaType == .anime) {
                    animeEntry = AnimeEntry(
                        progressStatus: ProgressStatus.Anime(rawValue: selectedMedia?.node.listStatus?.status ?? "") ?? .watching,
                        score: selectedMedia?.node.listStatus?.rating ?? 0,
                        currentEpisode: selectedMedia?.node.listStatus?.watchedEpisodes ?? 0,
                        totalEpisodes: selectedMedia?.node.episodes ?? 0,
                        comments: selectedMedia?.node.listStatus?.comments ?? "",
                        startDate: selectedMedia?.node.listStatus?.startDate ?? "",
                        finishDate: selectedMedia?.node.listStatus?.finishDate ?? ""
                    )
                    if animeEntry.comments != "" {
                        showComments = true
                    }
                    if animeEntry.startDate != "" || animeEntry.finishDate != "" {
                        showDates = true
                        startDate = stringToDate(animeEntry.startDate)
                        endDate = stringToDate(animeEntry.finishDate)
                    }
                }
            }
        }
    }
    
    private func stringToDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
    
    private func fetchLibrary() {
        if (tokenHandler.isAuthenticated) {
            Task {
                alertManager.isLoading = true
                do {
                    if libraryManager.mediaType == .manga {
                        libraryResponse = try await mangaController.fetchLibrary()
                    } else if libraryManager.mediaType == .anime {
                        libraryResponse = try await animeController.fetchLibrary()
                    }
                } catch {
                    print("Error fetching library: \(error)")
                }
                alertManager.isLoading = false
            }
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(AlertManager.shared)
}
