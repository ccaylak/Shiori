import SwiftUI
import KeychainSwift
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var code: String = ""
    @State private var codeChallenge: String = ""
    @State private var isAuthenticated: String = "0"
    
    @State private var profileDetails: ProfileDetails?
    
    @State private var mangasCompleted: Int?
    @State private var mangasReading: Int?
    @State private var mangasDropped: Int?
    @State private var mangasOnHold: Int?
    @State private var mangasPlanToRead: Int?
    
    private var profileController = ProfileController()
    
    let keychain = KeychainSwift()
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                if isAuthenticated != "0" {
                    HStack(alignment: .center, spacing: 12) {
                        AsyncImageView(imageUrl: profileDetails?.profilePicture ?? "https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg")
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        
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
                    .padding(.horizontal)
                    Form {
                        let animeStatistics = [
                            Statistics(title: "Completed", value: profileDetails?.animeStatistics?.completed ?? 0),
                            Statistics(title: "Watching", value: profileDetails?.animeStatistics?.watching ?? 0),
                            Statistics(title: "On hold", value: profileDetails?.animeStatistics?.onHold ?? 0),
                            Statistics(title: "Dropped", value: profileDetails?.animeStatistics?.dropped ?? 0),
                            Statistics(title: "Plan to watch", value: profileDetails?.animeStatistics?.planToWatch ?? 0),
                        ]
                        
                        UserStatistics(title: "Anime statistics", statisticsValues: animeStatistics)
                        
                        let mangaStatistics = [
                            Statistics(title: "Completed", value: mangasCompleted ?? 0),
                            Statistics(title: "Reading", value: mangasReading ?? 0),
                            Statistics(title: "On hold", value: mangasOnHold ?? 0),
                            Statistics(title: "Dropped", value: mangasDropped ?? 0),
                            Statistics(title: "Planned to read", value: mangasPlanToRead ?? 0),
                        ]
                        
                        UserStatistics(title: "Manga statistics", statisticsValues: mangaStatistics)

                    }
                    .onAppear {
                        Task {
                            profileDetails = try await profileController.fetchUserProfile()
                            mangasCompleted = try await profileController.fetchMangaStatistics(status: "completed")
                            mangasReading = try await profileController.fetchMangaStatistics(status: "reading")
                            mangasDropped = try await profileController.fetchMangaStatistics(status: "dropped")
                            mangasOnHold = try await profileController.fetchMangaStatistics(status: "on_hold")
                            mangasPlanToRead = try await profileController.fetchMangaStatistics(status: "plan_to_read")
                            
                        }
                    }
                }
                
                if isAuthenticated == "0" {
                    Button(action: {
                        Task {
                            do {
                                let urlWithToken = try await webAuthenticationSession.authenticate(using: generateLoginUrl()!, callbackURLScheme: "yourapp", preferredBrowserSession: .shared)
                                await signIn(using: urlWithToken)
                            } catch {
                                print("Authentication failed: \(error)")
                            }
                        }
                    }) {
                        Text("Login with MyAnimeList")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Login")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if isAuthenticated != "0", let profileName = profileDetails?.name,
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
                    if isAuthenticated != "0" {
                        Button(action: {
                            keychain.delete("accessToken")
                            isAuthenticated = "0"
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
            }
        }
        .onAppear {
            isAuthenticated = keychain.get("accessToken") ?? "0"
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
                        .foregroundColor(.white)
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
            
            let accessToken = content.accessToken
            let accessTokenData = Data(accessToken.utf8)
            
            keychain.set(accessTokenData, forKey: "accessToken")
            isAuthenticated = keychain.get("accessToken")!
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
