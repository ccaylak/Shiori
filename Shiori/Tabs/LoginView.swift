import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var code: String = ""
    @State private var codeChallenge: String = ""
    
    @State private var profileDetails: ProfileDetails?
    
    @State private var animeStatistics: JikanResponse.AnimeManga.AnimeStatistics?
    @State private var mangaStatistics: JikanResponse.AnimeManga.MangaStatistics?
    
    @State private var isAuthenticating: Bool = false
    
    private var jikanProfileController = JikanProfileController()
    private var profileController = ProfileController()
    
    @StateObject private var tokenHandler: TokenHandler = .shared
    private var malService: MALService = .shared
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 30) {
                if tokenHandler.isAuthenticated {
                    Form {
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
                                
                                if let birthDate = profileDetails?.birthDate {
                                    HStack {
                                        Text("Birthdate:")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(String.formatDateStringWithLocale(birthDate, fromFormat: "yyyy-MM-dd")!)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                    }
                                }
                                
                                if let gender = profileDetails?.gender {
                                    HStack {
                                        Text("Gender:")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(gender.capitalized)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                    }
                                }
                                
                                if let joinDate = profileDetails?.joinDate {
                                    HStack {
                                        Text("Join Date:")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(String.formatDateStringWithLocale(joinDate, fromFormat: "yyyy-MM-dd'T'HH:mm:ssZ")!)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                    }
                                }
                                
                                if let location = profileDetails?.location {
                                    HStack {
                                        Text("Location:")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(location)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                        
                        let animeStatistics = [
                            Statistics(title: "Completed", value: animeStatistics?.completed ?? 0),
                            Statistics(title: "Watching", value: animeStatistics?.watching ?? 0),
                            Statistics(title: "On hold", value: animeStatistics?.onHold ?? 0),
                            Statistics(title: "Dropped", value: animeStatistics?.dropped ?? 0),
                            Statistics(title: "Plan to watch", value: animeStatistics?.planToWatch ?? 0),
                        ]
                        
                        UserStatistics(title: "Anime statistics", statisticsValues: animeStatistics)
                        
                        let mangaStatistics = [
                            Statistics(title: "Completed", value: mangaStatistics?.completed ?? 0),
                            Statistics(title: "Reading", value: mangaStatistics?.reading ?? 0),
                            Statistics(title: "On hold", value: mangaStatistics?.onHold ?? 0),
                            Statistics(title: "Dropped", value: mangaStatistics?.dropped ?? 0),
                            Statistics(title: "Planned to read", value: mangaStatistics?.planToRead ?? 0),
                        ]
                        
                        UserStatistics(title: "Manga statistics", statisticsValues: mangaStatistics)

                    }
                    .onAppear {
                        Task {
                                profileDetails = try await profileController.fetchUserProfile()
                                
                                let response = try await jikanProfileController.fetchProfileStatistics(username: profileDetails?.name ?? "test")
                                
                                animeStatistics = response.data.anime
                                mangaStatistics = response.data.manga
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
                            Label("Share profile", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: SettingsView()) {
                        Label("Go to Settings", systemImage: "gearshape.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if tokenHandler.isAuthenticated {
                        Button(action: {
                            tokenHandler.revokeToken()
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
            }
        }
    }
    
    struct Statistics {
        let title: String
        let value: Int
    }
    
    struct UserStatistics: View {
        let title: String
        
        let statisticsValues: [Statistics]
        
        var body: some View {
            Section(title) {
                ForEach(statisticsValues, id: \.title) { stat in
                    StatisticsRow(title: stat.title, value: stat.value)
                }
            }
        }
        
        struct StatisticsRow: View {
            let title: String
            let value: Int
            
            var body: some View {
                HStack {
                    Text(title)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(value)")
                        .foregroundColor(.primary)
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
            
            tokenHandler.setRefreshToken(Data(content.refreshToken.utf8))
            tokenHandler.setToken(Data(content.accessToken.utf8))
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
