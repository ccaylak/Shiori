import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    
    private var jikanProfileController = JikanProfileController()
    private var userController = UserController()
    private var malService: MALService = .shared
    
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
                                    ForEach(
                                        favoriteMangas,
                                        id: \.malId
                                    ) { manga in
                                        /*NavigationLink(destination: DetailsView(
                                            media: MediaNode(
                                                id: manga.malId,
                                                title: manga.title ?? "",
                                                mainPicture: Picture(),
                                                mediatype: "tv"
                                            )))*/
                                        //{
                                            VStack {
                                                AsyncImageView(imageUrl: manga.images.jpgImage.baseImage)
                                                    .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                                    .cornerRadius(12)
                                                    .strokedBorder()
                                                
                                                Text(manga.title ?? "–")
                                                    .font(.caption)
                                                    .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }
                                        //}.buttonStyle(.plain)
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
                                        //NavigationLink(destination: DetailsView(media: MediaNode(
                                         //   id: anime.malId,
                                          //  title: anime.title ?? "-",
                                           // mainPicture: Picture(),
                                           // type: anime.type?.lowercased() ?? "Unknown"
                                        //))) {
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
                                        //}.buttonStyle(.plain)
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
                                do {
                                    let urlWithToken = try await webAuthenticationSession.authenticate(using: generateLoginUrl()!, callbackURLScheme: "yourapp", preferredBrowserSession: .shared)
                                    await signIn(using: urlWithToken)
                                } catch {
                                    print("Authentication failed: \(error)")
                                }
                                isAuthenticating = false
                            }
                        } label: {
                            Text("Log in with MyAnimeList")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
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
    
    func signIn(using url: URL) async {
        do {
            getCodeValueFromUrl(url)
            if code.isEmpty { return }
            
            let baseURLString = "https://myanimelist.net/v1/oauth2/token"
            var requestBody = "client_id=\(Config.apiKey)&"
            requestBody += "code=\(code)&"
            requestBody += "code_verifier=\(codeChallenge)&"
            requestBody += "grant_type=authorization_code"
            
            guard let url = URL(string: baseURLString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestBody.data(using: .utf8)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error: HTTP request failed with status code \(httpResponse.statusCode)")
                return
            }
            
            let content = try JSONDecoder
                .snakeCaseDecoder
                .decode(TokenResponse.self, from: data)
            tokenHandler.setTokens(from: content)
        } catch {
            print("Error during sign-in: \(error)")
        }
    }
    
    func getCodeValueFromUrl(_ url: URL) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        guard let queryItems = urlComponents.queryItems else { return }
        
        for queryItem in queryItems {
            if queryItem.name == "code" {
                code = queryItem.value ?? ""
            }
        }
    }
    
    func getNewCodeVerifier() -> String {
        let allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        var result = ""
        
        for _ in 0..<128 {
            let randomIndex = Int(arc4random_uniform(UInt32(allowedCharacters.count)))
            let randomCharacter = allowedCharacters[allowedCharacters.index(allowedCharacters.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        
        return result
    }
    
    func generateLoginUrl() -> URL?{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "myanimelist.net"
        components.path = "/v1/oauth2/authorize"
        
        codeChallenge = getNewCodeVerifier()
        
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Config.apiKey),
            URLQueryItem(name: "state", value: UUID().uuidString),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "plain"),
        ]
        guard let url = components.url else { return nil}
        return url
    }
}

#Preview {
    LoginView()
}
