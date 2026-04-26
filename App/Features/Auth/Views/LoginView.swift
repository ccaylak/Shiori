import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    
    private var jikanProfileController = JikanProfileController()
    private var userController = UserController()
    private var malService: MALService = .shared
    private let authService = MALAuthService.shared
    
    @StateObject private var tokenHandler: TokenHandler = .shared
    
    @State private var code: String = ""
    @State private var codeChallenge: String = ""
    
    @State private var user: User?
    @State private var animeStats: JikanResponse.AnimeManga.AnimeStatistics?
    @State private var mangaStats: JikanResponse.AnimeManga.MangaStatistics?
    @State private var jikanFavorites: JikanFavorites = JikanFavorites(data: FavoriteData(anime: [], manga: [], characters: []))
    @State private var jikanFriends: JikanFriends = JikanFriends(data: [])
    
    @State private var isAuthenticating: Bool = false
    
    @State private var showLogoutConfirmationDialog: Bool = false
    
    @EnvironmentObject private var alertManager: AlertManager
    
    
    private var friends: [JikanFriendsData] {
        jikanFriends.data
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
    
    private var birthdateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: user?.birthday ?? "")
        return date?.formatted(.dateTime.day().month().year()) ?? "–"
    }

    private var joinDateText: String {
        let iso = ISO8601DateFormatter()
        guard let date = iso.date(from: user?.joinedAt ?? "") else { return "–" }
        return date.formatted(.dateTime.day().month().year())
    }

    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 30) {
                if tokenHandler.isAuthenticated {
                    Form {
                        if let username = user?.name {
                           VStack {
                               AsyncImageView(imageUrl: user?.pictureUrl ?? "")
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
                                Text(birthdateText)
                                .foregroundStyle(.primary)
                            } label: {
                                Label {
                                    Text("Birthdate")
                                } icon: {
                                    Image(systemName: "calendar")
                                }
                            }
                            .foregroundStyle(.secondary)
                            
                            if let gender = user?.gender {
                                LabeledContent {
                                    Text(Gender(rawValue: gender)?.displayName ?? String(localized: "Not specified"))
                                        .foregroundStyle(.primary)
                                } label: {
                                    Label {
                                        Text("Gender")
                                    } icon: {
                                        Image(systemName: "person.fill")
                                    }
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            LabeledContent {
                                Text(joinDateText)
                                .foregroundStyle(.primary)
                            } label: {
                                Label {
                                    Text("Join date")
                                } icon: {
                                    Image(systemName: "calendar.and.person")
                                }
                            }
                            .foregroundStyle(.secondary)
                            
                            if let location = user?.location, !location.isEmpty {
                                LabeledContent {
                                    Text(location)
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
                                                
                                                Text(character.preferredNameFormat)
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
                    .onAppear {
                        Task {
                            alertManager.isLoading = true
                            defer { alertManager.isLoading = false }
                            user = try await userController.fetchUserProfile()
                            jikanFavorites = try await jikanProfileController.fetchProfileFavorites(username: user?.name ?? "test")
                            jikanFriends = try await jikanProfileController.fetchFriends(username: user?.name ?? "test")
                            let response = try await jikanProfileController.fetchProfileStatistics(username: user?.name ?? "test")
                            animeStats = response.data.anime
                            mangaStats = response.data.manga
                        }
                    }
                }
                
                if !tokenHandler.isAuthenticated {
                    VStack(spacing: 20) {
                        GroupBox {
                            Text("Log in with your MyAnimeList account to track your Anime and Manga progress, rate titles, and access personalized features.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Label("Info", systemImage: "info.circle")
                                .font(.headline)
                        }
                        
                        Button {
                            Task {
                                isAuthenticating = true
                                defer { isAuthenticating = false }
                                
                                do {
                                    guard let loginURL = authService.generateLoginURL() else { return }
                                    
                                    let callbackURL = try await webAuthenticationSession.authenticate(
                                        using: loginURL,
                                        callbackURLScheme: "yourapp",
                                        preferredBrowserSession: .shared
                                    )
                                    
                                    let tokenResponse = try await authService.exchangeCode(from: callbackURL)
                                    tokenHandler.setTokens(from: tokenResponse)
                                } catch {
                                    print("Authentication failed: \(error)")
                                }
                            }
                        } label: {
                            HStack(alignment: .center) {
                                Text("Log in with")
                                    .fontWeight(.semibold)
                                
                                Image("mal_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(Color.white)
                                    .frame(height: 16)
                            }
                        }
                        .borderedProminentOrGlassProminent()
                        .disabled(isAuthenticating)
                        .overlay {
                            if isAuthenticating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        
                        Text("To use these features, you can create an account at MyAnimeList.net.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .noScrollEdgeEffect()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle(tokenHandler.isAuthenticated ? "" : "Login")
            .navigationBarTitleDisplayMode(tokenHandler.isAuthenticated ? .inline : .large)
            .toolbar {
                ToolbarItem {
                    if tokenHandler.isAuthenticated, let profileName = user?.name,
                       let url = URL(string: "https://myanimelist.net/profile/\(profileName)") {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.fixed)
                }
                
                ToolbarItem {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                
                if tokenHandler.isAuthenticated {
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
                                Button("Yes", role: .destructive) { tokenHandler.revokeTokens() }
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
                    Text("\(value)")
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
    LoginView()
}
