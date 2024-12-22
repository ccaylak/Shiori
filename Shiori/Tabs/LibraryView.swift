import SwiftUI

struct LibraryView: View {
    
    @State private var mangaProgressSelection = MangaProgressStatus.completed
    @State private var libraryMangaSort = LibraryMangaSort.score
    
    @State private var animeProgressSelection = AnimeProgressStatus.completed
    @State private var libraryAnimeSort = LibraryAnimeSort.score
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    
    @State private var libraryResponse = LibraryResponse(data: [])
    
    @State private var selectedMedia: MediaNode?
    
    @State private var mangaStatus = MangaProgressStatus.reading
    @State private var animeStatus = AnimeProgressStatus.watching
    
    @State private var score: Int = 1
    @State private var progress: Int = 0
    @State private var endChapters: Int = 0
    
    @State private var showAlert = false
    
    @State private var searchTerm = ""
    
    private let mangaController = MangaController()
    private let animeController = AnimeController()
    
    @ObservedObject private var tokenHandler: TokenHandler = .shared
    
    private var filteredLibraryData: [MediaNode] {
        if searchTerm.isEmpty {
            return libraryResponse.data
        } else {
            return libraryResponse.data.filter { media in
                media.node.title.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if(tokenHandler.isAuthenticated) {
                        Text("\(mangaProgressSelection.rawValue.capitalized) (\(filteredLibraryData.count))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        if (mediaType == .manga) {
                            ForEach(filteredLibraryData, id: \.self) { manga in
                                Button(action: {
                                    selectedMedia = manga
                                }) {
                                    LibraryMediaView(
                                        title: manga.node.title,
                                        image: manga.node.images.large,
                                        releaseYear: manga.node.getReleaseYear,
                                        type: manga.node.getType,
                                        rating: manga.getListStatus.getRating,
                                        completedUnits: manga.getListStatus.getReadChapters,
                                        totalUnits: manga.node.getChapters
                                    )
                                }
                            }
                        }
                        if (mediaType == .anime) {
                            Text("\(animeProgressSelection.rawValue.capitalized) (\(filteredLibraryData.count))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            ForEach(filteredLibraryData, id: \.self) { anime in
                                Button(action: {
                                    selectedMedia = anime
                                }) {
                                    LibraryMediaView(
                                        title: anime.node.title,
                                        image: anime.node.images.large,
                                        releaseYear: anime.node.getReleaseYear,
                                        type: anime.node.getType,
                                        rating: anime.getListStatus.getRating,
                                        completedUnits: anime.getListStatus.getWatchedEpisodes,
                                        totalUnits: anime.node.getEpisodes
                                    )
                                }
                            }
                        }
                        if (filteredLibraryData.isEmpty) {
                            ContentUnavailableView.search
                        }
                    }
                    else {
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Menu {
                        Text("Select media")
                        Picker("Manga oder Anime", selection: $mediaType) {
                            Label("Manga", systemImage: "book")
                                .tag(MediaType.manga)
                            Label("Anime", systemImage: "tv")
                                .tag(MediaType.anime)
                        }
                    } label: {
                        Label("Media selection", systemImage: "sparkles")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        if (mediaType == .anime) {
                            Picker("Filter by", selection: $animeProgressSelection) {
                                ForEach(AnimeProgressStatus.allCases, id: \.self) { animeSelection in
                                    Text(animeSelection.displayName).tag(animeSelection.rawValue)
                                }
                            }
                            Picker("Sort by", selection: $libraryAnimeSort) {
                                ForEach(LibraryAnimeSort.allCases, id: \.self) { sortSelection in
                                    Text(sortSelection.displayName).tag(sortSelection.rawValue)
                                }
                            }
                        } else {
                            Picker("Filter by", selection: $mangaProgressSelection) {
                                ForEach(MangaProgressStatus.allCases, id: \.self) { mangaSelection in
                                    Text(mangaSelection.displayName).tag(mangaSelection.rawValue)
                                }
                            }
                            Picker("Sort by", selection: $libraryMangaSort) {
                                ForEach(LibraryMangaSort.allCases, id: \.self) { sortSelection in
                                    Text(sortSelection.displayName).tag(sortSelection.rawValue)
                                }
                            }
                        }
                    } label: {
                        Label("Sorting options", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .navigationTitle("\(mediaType.rawValue.capitalized) Library")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .sheet(item: $selectedMedia) { media in
                NavigationStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(media.node.getType)
                                .font(.subheadline)
                                .bold()
                            Text(media.node.title)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                        
                        AsyncImageView(imageUrl: media.node.images.large)
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        
                        List {
                            if (mediaType == .manga){
                                Picker("Status", selection: $mangaStatus) {
                                    ForEach([MangaProgressStatus.completed, .reading, .dropped, .onHold, .planToRead], id: \.self) { mangaSelection in
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
                                let chapterRange = endChapters > 0 ? 0...endChapters : 0...1000
                                ForEach(chapterRange, id: \.self) { chapter in
                                    Text("\(chapter)").tag(chapter)
                                }
                            }
                            
                            Picker("Rating", selection: $score) {
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
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Save") {
                                Task {
                                    if (mediaType == .manga) {
                                        try await mangaController.saveProgress(id: media.node.id, status: mangaStatus.rawValue, score: score, chapters: progress)
                                        libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryMangaSort.rawValue)
                                        selectedMedia = nil
                                    }
                                    if (mediaType == .anime) {
                                        try await animeController.saveProgress(id: media.node.id, status: animeStatus.rawValue, score: score, episodes: progress)
                                        libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryAnimeSort.rawValue)
                                        selectedMedia = nil
                                    }
                                }
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Edit")
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
                                            try await mangaController.deleteEntry(id: media.node.id)
                                            libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryMangaSort.rawValue)
                                        }
                                        if(mediaType == .anime) {
                                            try await animeController.deleteEntry(id: media.node.id)
                                            libraryResponse = try await animeController.fetchLibrary(status: animeProgressSelection.rawValue, sortOrder: libraryAnimeSort.rawValue)
                                        }
                                        showAlert = false
                                        selectedMedia = nil
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("Are you sure you want to delete \(media.node.title) from your library?")
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationDetents([.fraction(0.8)])
                    .presentationBackgroundInteraction(.disabled)
                    .presentationBackground(.regularMaterial)
                }
            }
        }
        .onAppear {
            Task {
                if (mediaType == .manga) {
                    libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryMangaSort.rawValue)
                }
                if (mediaType == .anime) {
                    libraryResponse = try await animeController.fetchLibrary(status: animeProgressSelection.rawValue, sortOrder: libraryAnimeSort.rawValue)
                }
            }
        }
        .onChange(of: mangaProgressSelection) {
            Task {
                libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryMangaSort.rawValue)
            }
        }
        .onChange(of: animeProgressSelection) {
            Task {
                libraryResponse = try await animeController.fetchLibrary(status: animeProgressSelection.rawValue, sortOrder: libraryAnimeSort.rawValue)
            }
        }
        .onChange(of: libraryMangaSort) {
            Task {
                libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryMangaSort.rawValue)
            }
        }
        .onChange(of: libraryAnimeSort) {
            Task {
                libraryResponse = try await animeController.fetchLibrary(status: animeProgressSelection.rawValue, sortOrder: libraryAnimeSort.rawValue)
            }
        }
        .onChange(of: selectedMedia) {
            if (mediaType == .manga) {
                score = selectedMedia?.listStatus?.rating ?? 0
                progress = selectedMedia?.listStatus?.readChapters ?? 0
                endChapters = selectedMedia?.node.numberOfChapters ?? 0
                mangaStatus = MangaProgressStatus(rawValue: selectedMedia?.listStatus?.status ?? "") ?? .reading
            }
            if (mediaType == .anime) {
                score = selectedMedia?.listStatus?.rating ?? 0
                progress = selectedMedia?.listStatus?.watchedEpisodes ?? 0
                endChapters = selectedMedia?.node.episodes ?? 0
                animeStatus = AnimeProgressStatus(rawValue: selectedMedia?.listStatus?.status ?? "") ?? .watching
            }
        }
        .onChange(of: mediaType) {
            Task {
                if (mediaType == .manga) {
                    libraryResponse = try await mangaController.fetchLibrary(status: mangaProgressSelection.rawValue, sortOrder: libraryMangaSort.rawValue)
                }
                if (mediaType == .anime) {
                    libraryResponse = try await mangaController.fetchLibrary(status: animeProgressSelection.rawValue, sortOrder: libraryAnimeSort.rawValue)
                }
            }
        }
    }
}
#Preview {
    LibraryView()
}
