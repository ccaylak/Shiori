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
    
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
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
                        if media.getEntryStatus != .notSet {
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
                                if (media.isMangaOrAnime == .anime && media.getMyListStatus.watchedEpisodes != 0) {
                                    Divider()
                                    VStack(spacing: 3) {
                                        Image(systemName: "tv.fill")
                                            .font(.subheadline)
                                        Text("Episode")
                                            .font(.caption)
                                        Text("\(media.getMyListStatus.watchedEpisodes)\(media.episodes != 0 ? "/\(media.episodes)" : "")")
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
                                        Text("\(media.getMyListStatus.readVolumes)\(media.volumes != 0 ? "/\(media.volumes)" : "")")
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
                            .background(Color(.secondarySystemGroupedBackground))
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
                                        try await animeController.addToWatchList(id: media.id)
                                        media = try await animeController.fetchDetails(id: media.id)
                                    }
                                    if (media.isMangaOrAnime == .manga) {
                                        try await mangaController.addToReadingList(id: media.id)
                                        media = try await mangaController.fetchDetails(id: media.id)
                                    }
                                }
                            } label : {
                                Label("Add to library",systemImage: "plus.circle.fill")
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
                            Picker("Progress", selection: $userProgress.progressStatus) {
                                ForEach([ProgressStatus.Manga.completed, .reading, .dropped, .onHold, .planToRead], id: \.self) { mangaSelection in
                                    Text(mangaSelection.displayName)
                                        .tag(mangaSelection.rawValue)
                                }
                            }
                            .isVisible(media.isMangaOrAnime == .manga)
                            
                            Picker("Progress", selection: $userProgress.progressStatus) {
                                ForEach([ProgressStatus.Anime.completed, .watching, .dropped, .onHold, .planToWatch],id: \.self) { animeSelection in
                                    Text(animeSelection.displayName)
                                        .tag(animeSelection.rawValue)
                                }
                            }
                            .isVisible(media.isMangaOrAnime == .anime)
                            
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
                                    Text("\(userProgress.readChapters)/\(media.chapters)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                ) {
                                    ForEach(0...media.chapters, id: \.self) { chapter in
                                        Text("\(chapter)").tag(chapter)
                                    }
                                }
                                .isVisible(media.chapters != 0 && (settingsManager.mangaFormat == .chapter || settingsManager.mangaFormat == .both))
                                
                                
                                LabeledContent("Chapters") {
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
                                        
                                        TextField("", value: $userProgress.readChapters, format: .number)
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
                                    (settingsManager.mangaFormat == .chapter || settingsManager.mangaFormat == .both)
                                )
                                
                                Picker(selection: $userProgress.readVolumes, label:
                                        VStack(alignment: .leading, spacing: 4) {
                                    Text("Volume")
                                    Text("\(userProgress.readVolumes)/\(media.volumes)")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                ) {
                                    ForEach(0...media.volumes, id: \.self) { volume in
                                        Text("\(volume)").tag(volume)
                                    }
                                }
                                .isVisible(media.volumes != 0 && (settingsManager.mangaFormat == .volume || settingsManager.mangaFormat == .both))
                                
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
                                        
                                        TextField("", value: $userProgress.readVolumes, format: .number)
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
                                    (settingsManager.mangaFormat == .volume || settingsManager.mangaFormat == .both)
                                )
                            }
                            .isVisible(media.isMangaOrAnime == .manga)
                            
                            Picker(selection: $userProgress.watchedEpisodes, label:
                                    VStack(alignment: .leading, spacing: 4) {
                                Text("Episode")
                                Text("\(userProgress.watchedEpisodes)/\(media.episodes)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            ) {
                                ForEach(0...media.episodes, id: \.self) { episode in
                                    Text("\(episode)").tag(episode)
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
                                    
                                    TextField("", value: $userProgress.watchedEpisodes, format: .number)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
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
                                
                                Picker("", selection: $userProgress.priority) {
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
                                        .foregroundStyle(showComments ? .red : Color.getByColorString(settingsManager.accentColor.rawValue))
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
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            if #available(iOS 26, *) {
                                Button(role: .confirm) {
                                    Task {
                                        if (media.isMangaOrAnime == .manga) {
                                            try await mangaController
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
                                            alertManager.showUpdatedAlert = true
                                            media = try await mangaController.fetchDetails(id: media.id)
                                            isSheetPresented = false
                                        }
                                        if (media.isMangaOrAnime == .anime) {
                                            try await animeController
                                                .saveProgress(
                                                    id: media.id,
                                                    status: userProgress.progressStatus,
                                                    score: userProgress.score,
                                                    episodes: userProgress.watchedEpisodes,
                                                    comments: userProgress.userComments,
                                                    startDate: startDate,
                                                    finishDate: finishDate
                                                )
                                            alertManager.showUpdatedAlert = true
                                            media = try await animeController.fetchDetails(id: media.id)
                                            isSheetPresented = false
                                        }
                                    }
                                }
                                .tint(Color.getByColorString(settingsManager.accentColor.rawValue)
                                )
                            } else {
                                Button("Save") {
                                    Task {
                                        if (media.isMangaOrAnime == .manga) {
                                            try await mangaController
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
                                            alertManager.showUpdatedAlert = true
                                            media = try await mangaController.fetchDetails(id: media.id)
                                            isSheetPresented = false
                                        }
                                        if (media.isMangaOrAnime == .anime) {
                                            try await animeController
                                                .saveProgress(
                                                    id: media.id,
                                                    status: userProgress.progressStatus,
                                                    score: userProgress.score,
                                                    episodes: userProgress.watchedEpisodes,
                                                    comments: userProgress.userComments,
                                                    startDate: startDate,
                                                    finishDate: finishDate
                                                )
                                            alertManager.showUpdatedAlert = true
                                            media = try await animeController.fetchDetails(id: media.id)
                                            isSheetPresented = false
                                        }
                                    }
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
                            .alert("Remove entry",isPresented: $showAlert) {
                                Button("Delete", role: .destructive) {
                                    didTap.toggle()
                                    Task {
                                        if (media.isMangaOrAnime == .manga) {
                                            try await mangaController.deleteEntry(id: media.id)
                                            alertManager.showRemovedAlert = true
                                            media = try await mangaController.fetchDetails(id: media.id)
                                        }
                                        if (media.isMangaOrAnime == .anime) {
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
                                Text("Do you really want to remove \(media.preferredTitle) from your library?")
                            }.sensoryFeedback(.warning, trigger: didTap)
                        }
                    }
                    .navigationTitle(media.isMangaOrAnime == .manga ? "Edit Reading Progress" : "Edit Watch Progress")
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationDetents([settingsManager.advancedMode ? .fraction(0.8) : .fraction(0.6)])
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
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                do {
                    if media.isMangaOrAnime == .anime {
                        media = try await animeController.fetchDetails(id: media.id)
                        
                        jikanCharacters = try await jikanCharacterController.fetchAnimeCharacter(id: media.id)
                        jikanRelations = try await jikanRelationsController.fetchAnimeRelations(id: media.id)
                        
                        userProgress = media.getMyListStatus
                    }
                    
                    if media.isMangaOrAnime == .manga {
                        media = try await mangaController.fetchDetails(id: media.id)
                        
                        jikanCharacters = try await jikanCharacterController.fetchMangaCharacter(id: media.id)
                        jikanRelations = try await jikanRelationsController.fetchMangaRelations(id: media.id)
                        
                        userProgress = media.getMyListStatus
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
