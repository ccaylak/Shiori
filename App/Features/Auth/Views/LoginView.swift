import SwiftUI
import AuthenticationServices
import TelemetryDeck
import SwiftData

struct LoginView: View {
    @AppStorage("animeScheduleLastRefresh")
    private var animeScheduleLastRefresh: Double = 0
    
    @Environment(\.webAuthenticationSession)
    private var webAuthenticationSession
    
    @Environment(AccountSession.self)
    private var accountSession
    
    @State private var viewModel = LoginViewModel()
    
    private let jikanProfileController = JikanProfileController()
    
    @State private var animeStats: JikanResponse.AnimeManga.AnimeStatistics?
    @State private var mangaStats: JikanResponse.AnimeManga.MangaStatistics?
    @State private var jikanFavorites: JikanFavorites = JikanFavorites(data: FavoriteData(anime: [], manga: [], characters: []))
    @State private var jikanFriends: JikanFriends = JikanFriends(data: [])
    
    @State private var showLogoutConfirmationDialog: Bool = false
    
    @Environment(ToastManager.self)
    private var toastManager
    
    @Environment(AppSettings.self)
    private var settings
    
    @Environment(\.modelContext)
    private var modelContext
    
    private var profile: AccountProfile? {
        accountSession.profile
    }
    
    private var friends: [JikanFriendsData] {
        jikanFriends.data
    }

    private func clearJikanProfileData() {
        jikanFavorites = JikanFavorites(
            data: FavoriteData(anime: [], manga: [], characters: [])
        )
        jikanFriends = JikanFriends(data: [])
        animeStats = nil
        mangaStats = nil
    }
    
    private func clearAnimeSchedule() throws {
        let schedules = try modelContext.fetch(
            FetchDescriptor<AnimeSchedule>()
        )

        for schedule in schedules {
            modelContext.delete(schedule)
        }

        try modelContext.save()

        animeScheduleLastRefresh = 0
    }
    
    private func loadProfile() async {
        guard accountSession.isAuthenticated else {
            return
        }

        toastManager.isLoading = true
        defer { toastManager.isLoading = false }

        if accountSession.profile == nil {
            await viewModel.loadProfile(
                session: accountSession
            )
        }

        guard
            accountSession.activeProvider == .myAnimeList,
            let username = accountSession.profile?.username,
            settings.isExtendedDataEnabled,
            settings.extendedDataSource == .jikan
        else {
            clearJikanProfileData()
            return
        }

        do {
            async let favorites =
                jikanProfileController.fetchProfileFavorites(
                    username: username,
                    apiService: settings.extendedDataSource
                )

            async let friends =
                jikanProfileController.fetchFriends(
                    username: username,
                    apiService: settings.extendedDataSource
                )

            async let statistics =
                jikanProfileController.fetchProfileStatistics(
                    username: username,
                    apiService: settings.extendedDataSource
                )

            jikanFavorites = try await favorites
            jikanFriends = try await friends

            let response = try await statistics
            animeStats = response.data.anime
            mangaStats = response.data.manga
        } catch {
            print("Failed to load profile data:", error)
            clearJikanProfileData()
        }
    }
    
    private func authenticate(
        loginURL: URL,
        callbackScheme: String
    ) async throws -> URL {
        try await webAuthenticationSession.authenticate(
            using: loginURL,
            callbackURLScheme: callbackScheme,
            preferredBrowserSession: .shared
        )
    }

    private var favoriteMangas: [FavoriteEntry] { jikanFavorites.data.manga }
    private var favoriteAnimes: [FavoriteEntry] { jikanFavorites.data.anime }
    private var favoriteCharacters: [FavoriteEntry] { jikanFavorites.data.characters }

    private var animeStatisticsValues: [Statistics] {
        [
            Statistics(
                title: ProgressStatus.Anime.completed.displayName,
                icon: AnyView(ProgressStatus.Anime.completed.libraryIcon),
                value: animeStats?.completed ?? 0
            ),
            Statistics(
                title: ProgressStatus.Anime.watching.displayName,
                icon: AnyView(ProgressStatus.Anime.watching.libraryIcon),
                value: animeStats?.watching ?? 0
            ),
            Statistics(
                title: ProgressStatus.Anime.onHold.displayName,
                icon: AnyView(ProgressStatus.Anime.onHold.libraryIcon),
                value: animeStats?.onHold ?? 0
            ),
            Statistics(
                title: ProgressStatus.Anime.dropped.displayName,
                icon: AnyView(ProgressStatus.Anime.dropped.libraryIcon),
                value: animeStats?.dropped ?? 0
            ),
            Statistics(
                title: ProgressStatus.Anime.planToWatch.displayName,
                icon: AnyView(ProgressStatus.Anime.planToWatch.libraryIcon),
                value: animeStats?.planToWatch ?? 0
            )
        ]
    }

    private var mangaStatisticsValues: [Statistics] {
        [
            Statistics(
                title: ProgressStatus.Manga.completed.displayName,
                icon: AnyView(ProgressStatus.Manga.completed.libraryIcon),
                value: mangaStats?.completed ?? 0
            ),
            Statistics(
                title: ProgressStatus.Manga.reading.displayName,
                icon: AnyView(ProgressStatus.Manga.reading.libraryIcon),
                value: mangaStats?.reading ?? 0
            ),
            Statistics(
                title: ProgressStatus.Manga.onHold.displayName,
                icon: AnyView(ProgressStatus.Manga.onHold.libraryIcon),
                value: mangaStats?.onHold ?? 0
            ),
            Statistics(
                title: ProgressStatus.Manga.dropped.displayName,
                icon: AnyView(ProgressStatus.Manga.dropped.libraryIcon),
                value: mangaStats?.dropped ?? 0
            ),
            Statistics(
                title: ProgressStatus.Manga.planToRead.displayName,
                icon: AnyView(ProgressStatus.Manga.planToRead.libraryIcon),
                value: mangaStats?.planToRead ?? 0
            )
        ]
    }
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 30) {
                if accountSession.isAuthenticated {
                    Form {
                        if let username = profile?.username {
                           VStack {
                               AsyncImageView(imageUrl: profile?.avatarURL ?? "")
                                   .frame(
                                    width: CoverSize.medium.size.width,
                                          height: CoverSize.small.size.height
                                   )
                                   .cornerRadius(12)
                                   .strokedBorder()
                               
                               Text(username)
                                   .font(.title2)
                                   .bold()
                           }
                           .listRowBackground(Color.clear)
                           .frame(maxWidth: .infinity, alignment: .center)
                           .listRowInsets(EdgeInsets())
                        }
                        Section {
                            LabeledContent {
                                Text(profile?.birthday?.formatted(date: .numeric, time: .omitted) ?? "–")
                                .foregroundStyle(.primary)
                            } label: {
                                Label {
                                    Text("Birthdate")
                                } icon: {
                                    Image(systemName: "calendar")
                                }
                            }
                            .foregroundStyle(.secondary)
                            
                            LabeledContent {
                                Text(
                                    profile?.gender
                                        .flatMap { Gender(rawValue: $0) }?
                                        .displayName
                                    ?? String(localized: "Not specified")
                                )
                                .foregroundStyle(.primary)
                            } label: {
                                Label {
                                    Text("Gender")
                                } icon: {
                                    Image(systemName: "person.fill")
                                }
                            }
                            .foregroundStyle(.secondary)
                            
                            LabeledContent {
                                Text(profile?.joinedAt?.formatted(date: .numeric, time: .omitted) ?? "–")
                                    .foregroundStyle(.primary)
                            } label: {
                                Label {
                                    Text("Join date")
                                } icon: {
                                    Image(systemName: "calendar.and.person")
                                }
                            }
                            .foregroundStyle(.secondary)
                            
                            LabeledContent {
                                Text(profile?.location?.capitalized ?? "–")
                                    .foregroundStyle(.primary)
                            } label: {
                                Label {
                                    Text("Location")
                                } icon: {
                                    Image(systemName: "mappin.and.ellipse")
                                }
                            }
                            .foregroundStyle(.secondary)
                        }
                        
                        Section(header: Label("Friends", systemImage: "person.3")) {
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(friends, id: \.user.username) { friend in
                                        VStack {
                                            AsyncImageView(imageUrl: friend.user.images.jpgImage.baseImage)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(12)
                                                .strokedBorder()
                                            
                                            Text(friend.user.username)
                                                .font(.caption2)
                                                .frame(maxWidth: 60, alignment: .center)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollIndicators(.hidden)
                            .scrollClipDisabled()
                        }
                        .isVisible(!friends.isEmpty)
                        
                        if settings.isExtendedDataEnabled && settings.extendedDataSource == .jikan  {
                            UserStatistics(
                                title: String(localized: "Anime Statistics"),
                                icon: "tv",
                                statisticsValues: animeStatisticsValues
                            )
                            
                            UserStatistics(
                                title: String(localized: "Manga Statistics"),
                                icon: "character.book.closed.ja",
                                statisticsValues: mangaStatisticsValues
                            )
                        }
                        
                        Section(header: Label("Favorite Manga", systemImage: "heart")) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(favoriteMangas, id: \.malId) { manga in
                                        NavigationLink {
                                            DetailsView(
                                                media: MediaNode(
                                                    id: manga.malId,
                                                    title: manga.title ?? "",
                                                    mainPicture: Picture(
                                                        large: manga.images.jpgImage.largeImage,
                                                        medium: manga.images.jpgImage.baseImage
                                                    ),
                                                    mediaType: "manga"
                                                )
                                            )
                                        } label: {
                                            VStack {
                                                AsyncImageView(imageUrl: manga.images.jpgImage.baseImage)
                                                    .frame(
                                                        width: CoverSize.medium.size.width,
                                                        height: CoverSize.medium.size.height
                                                    )
                                                    .cornerRadius(12)
                                                    .strokedBorder()

                                                Text(manga.title ?? "–")
                                                    .font(.caption)
                                                    .frame(
                                                        maxWidth: CoverSize.medium.size.width,
                                                        alignment: .leading
                                                    )
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollClipDisabled()
                        }
                        .isVisible(!favoriteMangas.isEmpty)
                        
                        Section(header: Label("Favorite Anime", systemImage: "heart")) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(favoriteAnimes, id: \.malId) { anime in
                                        NavigationLink(destination: DetailsView(media: MediaNode(
                                            id: anime.malId,
                                            title: anime.title ?? "-",
                                            mainPicture: Picture(large: anime.images.jpgImage.largeImage, medium: anime.images.jpgImage.baseImage),
                                            mediaType: "tv"
                                        ))) {
                                            VStack {
                                                AsyncImageView(imageUrl: anime.images.jpgImage.baseImage)
                                                    .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                                    .cornerRadius(12)
                                                    .strokedBorder()
                                                
                                                Text(anime.title ?? "–")
                                                    .font(.caption)
                                                    .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }
                                        }.buttonStyle(.plain)
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollClipDisabled()
                        }
                        .isVisible(!favoriteAnimes.isEmpty)
                    
                        Section(header: Label("Favorite Characters", systemImage: "person.3.sequence")) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(jikanFavorites.data.characters, id: \.malId) { character in
                                        /*
                                        NavigationLink(
                                            destination: CharacterDetailsView(
                                                metaData: MetaData(
                                                    malId: character.malId,
                                                    name: character.formattedName,
                                                    images: JikanImages(large: character.images.jpgImage.baseImage)
                                                ),
                                                role: ""
                                            )
                                        ) {*/
                                            VStack {
                                                AsyncImageView(imageUrl: character.images.jpgImage.baseImage)
                                                    .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                                    .cornerRadius(12)
                                                    .strokedBorder()
                                                
                                                Text(character.preferredName(format: settings.nameFormat))
                                                    .font(.caption)
                                                    .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }
                                        }.buttonStyle(.plain)
                                    }
                            //}.scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollClipDisabled()
                        }
                        .isVisible(!favoriteCharacters.isEmpty)
                        
                    }
                    .task(id: accountSession.activeProvider) {
                        guard accountSession.isAuthenticated else {
                            clearJikanProfileData()
                            return
                        }

                        await loadProfile()
                    }
                }
                
                if !accountSession.isAuthenticated {
                    VStack(spacing: 20) {
                        GroupBox {
                            Text(
                                "Log in with your MyAnimeList or AniList account to track your Anime and Manga progress, rate titles, and access personalized features."
                            )
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                        } label: {
                            Label("Info", systemImage: "info.circle")
                                .font(.headline)
                        }

                        VStack(spacing: 12) {
                            Button {
                                Task {
                                    await viewModel.login(
                                        with: .myAnimeList,
                                        session: accountSession,
                                        authenticate: authenticate
                                    )
                                }
                            } label: {
                                HStack {
                                    Text("Log in with")
                                        .fontWeight(.semibold)

                                    Image("mal_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(height: 16)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .borderedProminentOrGlassProminent()

                            Button {
                                Task {
                                    await viewModel.login(
                                        with: .aniList,
                                        session: accountSession,
                                        authenticate: authenticate
                                    )
                                }
                            } label: {
                                HStack {
                                    Text("Log in with")
                                        .fontWeight(.semibold)

                                    Text("AniList")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .borderedProminentOrGlassProminent()
                        }
                        .disabled(viewModel.isAuthenticating)
                        .overlay {
                            if viewModel.isAuthenticating {
                                ProgressView()
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity
                                    )
                            }
                        }

                        Text(
                            "You can create an account on MyAnimeList.net or AniList.co."
                        )
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .noScrollEdgeEffect()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle(
                accountSession.isAuthenticated
                    ? Text(verbatim: "")
                    : Text("Login")
            )
            .navigationBarTitleDisplayMode(accountSession.isAuthenticated ? .inline : .large)
            .toolbar {
                ToolbarItem {
                    if
                        let profileURL = accountSession.profile?.profileURL,
                        let url = URL(string: profileURL)
                    {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.fixed)
                }
                
                ToolbarItem {
                    NavigationLink {
                        SettingsView()
                            .trackNavigation(path: "settings")
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                
                if accountSession.isAuthenticated {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showLogoutConfirmationDialog = true
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.accentColor)
                        }
                        .confirmationDialog(
                            Text("Do you really want to logout of your MAL-Account?"),
                            isPresented: $showLogoutConfirmationDialog,
                            titleVisibility: .visible,
                            actions: {
                                Button("Yes", role: .destructive) {
                                    Task {
                                        await AnimeNotificationManager
                                            .cancelNotifications()

                                        do {
                                            try clearAnimeSchedule()
                                        } catch {
                                            print(
                                                "Failed to clear anime schedule:",
                                                error
                                            )
                                        }

                                        clearJikanProfileData()

                                        await viewModel.logout(
                                            session: accountSession
                                        )
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            }
                        )
                    }
                }
            }
        }
    }
    
    struct Statistics {
        let title: String
        let icon: AnyView
        let value: Int
    }
    
    struct UserStatistics: View {
        let title: String
        let icon: String
        let statisticsValues: [Statistics]
        
        var body: some View {
            Section(header: Label(title, systemImage: icon)) {
                ForEach(statisticsValues, id: \.title) { stat in
                    StatisticsRow(title: stat.title, icon: stat.icon, value: stat.value)
                }
            }
        }
        
        struct StatisticsRow: View {
            let title: String
            let icon: AnyView
            let value: Int
            
            var body: some View {
                LabeledContent {
                    Text(value, format: .number)
                } label: {
                    Label {
                        Text(title)
                    } icon: {
                        icon
                    }
                }
            }
        }
        
    }
}

#Preview {
    let malDependencies = MALDependencies()

    LoginView()
        .environment(malDependencies)
        .environment(
            AccountSession(
                malDependencies: malDependencies
            )
        )
        .environment(AppSettings())
        .environment(ToastManager())
        .modelContainer(
            for: AnimeSchedule.self,
            inMemory: true
        )
}
