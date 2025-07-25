import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    
    private var jikanProfileController = JikanProfileController()
    private var profileController = ProfileController()
    private var malService: MALService = .shared
    
    @StateObject private var tokenHandler: TokenHandler = .shared
    
    @State private var code: String = ""
    @State private var codeChallenge: String = ""
    
    @State private var profileDetails: ProfileDetails?
    @State private var animeStatistics: JikanResponse.AnimeManga.AnimeStatistics?
    @State private var mangaStatistics: JikanResponse.AnimeManga.MangaStatistics?
    @State private var jikanFavorites: JikanFavorites = JikanFavorites(data: FavoriteData(animes: [], mangas: [], characters: []))
    @State private var jikanFriends: JikanFriends = JikanFriends(data: [])
    
    @State private var isAuthenticating: Bool = false
    
    @State private var showLogoutConfirmationDialog: Bool = false
    
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 30) {
                if tokenHandler.isAuthenticated {
                    Form {
                        Section(header: Label("Profile", systemImage: "person.text.rectangle")) {
                            HStack(alignment: .center, spacing: 20) {
                                AsyncImageView(imageUrl: profileDetails?.profilePicture ?? "https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg")
                                    .frame(width: 80, height: 100)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                                VStack(alignment: .leading, spacing: 6) {
                                    if let name = profileDetails?.name {
                                        Text(name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    HStack(alignment: .center, spacing: 20) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "calendar")
                                                    .imageScale(.small)
                                                    .foregroundStyle(Color.secondary)
                                                Text("Birthdate")
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color.secondary)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "person.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(Color.secondary)
                                                Text("Gender")
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color.secondary)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "calendar.and.person")
                                                    .imageScale(.small)
                                                    .foregroundStyle(Color.secondary)
                                                Text("Join date")
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color.secondary)
                                            }
                                            
                                            HStack(spacing: 4){
                                                Image(systemName: "mappin.and.ellipse")
                                                    .imageScale(.small)
                                                    .foregroundStyle(Color.secondary)
                                                Text("Location")
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color.secondary)
                                            }
                                        }
                                        
                                        if let birthDate = profileDetails?.birthDate,
                                           let joinDate = profileDetails?.joinDate,
                                           let gender = profileDetails?.gender,
                                           let location = profileDetails?.location
                                            
                                        {
                                            VStack(alignment: .leading, spacing: 3) {
                                                if let formattedDate = String.formatDateStringWithLocale(birthDate, fromFormat: "yyyy-MM-dd") {
                                                    Text(formattedDate)
                                                        .font(.subheadline)
                                                        .foregroundColor(.primary)
                                                } else {
                                                    Text("Invalid date")
                                                        .font(.subheadline)
                                                        .foregroundColor(.primary)
                                                }
                                                
                                                Text(Gender(rawValue: gender)?.displayName ?? String(localized: "Not specified"))
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)
                                                
                                                if let formattedDate = String.formatDateStringWithLocale(joinDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ssZ") {
                                                    Text(formattedDate)
                                                        .font(.subheadline)
                                                        .foregroundColor(.primary)
                                                } else {
                                                    Text("Invalid date")
                                                }
                                                
                                                Text(location)
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        let friends = jikanFriends.data
                        if !friends.isEmpty {
                            Section(header: Label("Friends", systemImage: "person.3")) {
                                ScrollView(.horizontal) {
                                    HStack(spacing: 10) {
                                        ForEach(friends, id: \.self) { friend in
                                            VStack {
                                                AsyncImageView(imageUrl: friend.user.images.jpg.imageUrl ?? "")
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                                    )
                                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                                
                                                Text(friend.user.username)
                                                    .font(.caption)
                                                    .frame(alignment: .center)
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
                        }
                        
                        let animeStatistics: [Statistics] = [
                            Statistics(
                                title: ProgressStatus.Anime.completed.displayName,
                                icon: AnyView(ProgressStatus.Anime.completed.libraryIcon),
                                value: animeStatistics?.completed ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Anime.watching.displayName,
                                icon: AnyView(ProgressStatus.Anime.watching.libraryIcon),
                                value: animeStatistics?.watching ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Anime.onHold.displayName,
                                icon: AnyView(ProgressStatus.Anime.onHold.libraryIcon),
                                value: animeStatistics?.onHold ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Anime.dropped.displayName,
                                icon: AnyView(ProgressStatus.Anime.dropped.libraryIcon),
                                value: animeStatistics?.dropped ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Anime.planToWatch.displayName,
                                icon: AnyView(ProgressStatus.Anime.planToWatch.libraryIcon),
                                value: animeStatistics?.planToWatch ?? 0
                            ),
                        ]
                        UserStatistics(
                            title: String(localized: "Anime statistics"),
                            icon: "tv",
                            statisticsValues: animeStatistics
                        )
                        
                        let mangaStatistics: [Statistics] = [
                            Statistics(
                                title: ProgressStatus.Manga.completed.displayName,
                                icon: AnyView(ProgressStatus.Manga.completed.libraryIcon),
                                value: mangaStatistics?.completed ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Manga.reading.displayName,
                                icon: AnyView(ProgressStatus.Manga.reading.libraryIcon),
                                value: mangaStatistics?.reading ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Manga.onHold.displayName,
                                icon: AnyView(ProgressStatus.Manga.onHold.libraryIcon),
                                value: mangaStatistics?.onHold ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Manga.dropped.displayName,
                                icon: AnyView(ProgressStatus.Manga.dropped.libraryIcon),
                                value: mangaStatistics?.dropped ?? 0
                            ),
                            Statistics(
                                title: ProgressStatus.Manga.planToRead.displayName,
                                icon: AnyView(ProgressStatus.Manga.planToRead.libraryIcon),
                                value: mangaStatistics?.planToRead ?? 0
                            ),
                        ]
                        UserStatistics(
                            title: String(localized: "Manga statistics"),
                            icon: "character.book.closed.ja",
                            statisticsValues: mangaStatistics
                        )
                        
                        
                        let favoriteMangas = jikanFavorites.data.mangas
                        if !favoriteMangas.isEmpty {
                            Section(header: Label("Favorite manga", systemImage: "heart")) {
                                ScrollView(.horizontal) {
                                    HStack(spacing: 10) {
                                        ForEach(favoriteMangas, id: \.self) { manga in
                                            VStack {
                                                AsyncImageView(imageUrl: manga.images.jpg.imageUrl)
                                                    .frame(width: 100, height: 156)
                                                    .cornerRadius(12)
                                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                                
                                                Text(manga.title ?? "–")
                                                    .font(.caption)
                                                    .frame(width: 100, alignment: .leading)
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
                        }
                        
                        let favoriteAnimes = jikanFavorites.data.animes
                        if !favoriteAnimes.isEmpty {
                            Section(header: Label("Favorite animes", systemImage: "heart")) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(jikanFavorites.data.animes, id: \.self) { anime in
                                            VStack {
                                                AsyncImageView(imageUrl: anime.images.jpg.imageUrl)
                                                    .frame(width: 100, height: 156)
                                                    .cornerRadius(12)
                                                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 5)
                                                
                                                Text(anime.title ?? "–")
                                                    .font(.caption)
                                                    .frame(width: 100, alignment: .leading)
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
                        }
                        
                        let favoriteCharacters = jikanFavorites.data.characters
                        if !favoriteCharacters.isEmpty {
                            Section(header: Label("Favorite characters", systemImage: "person.3.sequence")) {
                                ScrollView(.horizontal) {
                                    HStack(spacing: 10) {
                                        ForEach(jikanFavorites.data.characters, id: \.self) { character in
                                            VStack {
                                                AsyncImageView(imageUrl: character.images.jpg.imageUrl)
                                                    .frame(width: 100, height: 156)
                                                    .cornerRadius(12)
                                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                                Text(character.formattedName)
                                                    .font(.caption)
                                                    .frame(width: 100, alignment: .leading)
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
                        }
                    }
                    .onAppear {
                        Task {
                            alertManager.isLoading = true
                            profileDetails = try await profileController.fetchUserProfile()
                            jikanFavorites = try await jikanProfileController.fetchProfileFavorites(username: profileDetails?.name ?? "test")
                            jikanFriends = try await jikanProfileController.fetchFriends(username: profileDetails?.name ?? "test")
                            let response = try await jikanProfileController.fetchProfileStatistics(username: profileDetails?.name ?? "test")
                            animeStatistics = response.data.anime
                            mangaStatistics = response.data.manga
                            alertManager.isLoading = false
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
                        
                        Button(action: {
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
                        }) {
                            Text("Log in with MyAnimeList")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle(tokenHandler.isAuthenticated ? "" : "Login")
            .navigationBarTitleDisplayMode(tokenHandler.isAuthenticated ? .inline : .large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if tokenHandler.isAuthenticated, let profileName = profileDetails?.name,
                       let url = URL(string: "https://myanimelist.net/profile/\(profileName)") {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                if tokenHandler.isAuthenticated {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showLogoutConfirmationDialog = true
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
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
                        .foregroundColor(.primary)
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
            
            let content = try JSONDecoder().decode(TokenResponse.self, from: data)
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
