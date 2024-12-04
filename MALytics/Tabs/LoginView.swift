import SwiftUI
import KeychainSwift
import AuthenticationServices

struct LoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var code: String = ""
    @State private var codeChallenge: String = ""
    @State private var isSignedIn: Bool = false
    
    @State private var profileDetails: ProfileDetails?
    
    @State private var mangasCompleted: Int?
    @State private var mangasReading: Int?
    @State private var mangasDropped: Int?
    @State private var mangasOnHold: Int?
    @State private var mangasPlanToRead: Int?
    
    private var malController = MyAnimeListAPIController()
    
    let keychain = KeychainSwift()
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                if isSignedIn {
                    HStack(alignment: .top, spacing: 12) {
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
                            Text(profileDetails?.name ?? "Unknown name")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text("Birthdate:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(profileDetails?.birthDate ?? "Unknown birthdate")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Gender:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(profileDetails?.gender ?? "Unknown gender")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Join Date:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(profileDetails?.joinDate ?? "Unknown join date")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Location:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(profileDetails?.location ?? "Unknown location")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    Form {
                        Section ("Anime statistics") {
                            StatisticsRow(title: "Completed", color: Color.getByRGB(49, 65, 114), value: profileDetails?.animeStatistics?.completed ?? 0)
                            StatisticsRow(title: "Watching", color: Color.getByRGB(74, 131, 74), value: profileDetails?.animeStatistics?.watching ?? 0)
                            StatisticsRow(title: "On hold", color: Color.getByRGB(195, 164, 63), value: profileDetails?.animeStatistics?.onHold ?? 0)
                            StatisticsRow(title: "Dropped", color: Color.getByRGB(121, 53, 51), value: profileDetails?.animeStatistics?.dropped ?? 0)
                            StatisticsRow(title: "Plan to watch", color: Color.getByRGB(116, 116, 116), value: profileDetails?.animeStatistics?.planToWatch ?? 0)
                        }
                        Section ("Manga statistics") {
                            StatisticsRow(title: "Completed", color: Color.getByRGB(49, 65, 114), value: mangasCompleted ?? 0)
                            StatisticsRow(title: "Reading", color: Color.getByRGB(74, 131, 74), value: mangasReading ?? 0)
                            StatisticsRow(title: "On hold", color: Color.getByRGB(195, 164, 63), value: mangasOnHold ?? 0)
                            StatisticsRow(title: "Dropped", color: Color.getByRGB(121, 53, 51), value: mangasDropped ?? 0)
                            StatisticsRow(title: "Planned to read", color: Color.getByRGB(116, 116, 116), value: mangasPlanToRead ?? 0)
                        }
                    }
                    .onAppear {
                        Task {
                            profileDetails = try await malController.loadProfileDetails()
                            mangasCompleted = try await malController.loadMangaStatistics(status: "completed")
                            mangasReading = try await malController.loadMangaStatistics(status: "reading")
                            mangasDropped = try await malController.loadMangaStatistics(status: "dropped")
                            mangasOnHold = try await malController.loadMangaStatistics(status: "on_hold")
                            mangasPlanToRead = try await malController.loadMangaStatistics(status: "plan_to_read")
                            
                        }
                    }
                    Button("Logout") {
                        isSignedIn = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("MyAnimeList Account")
            .toolbar {
                if(isSignedIn) {
                    ToolbarItem(placement: .primaryAction) {
                        ShareLink(
                            item: URL(string: "https://myanimelist.net/profile/\(profileDetails?.name)")!,
                            preview: SharePreview("Share profile", image: Image(systemName: "square.and.arrow.up"))
                        ) {
                            Label("Share profile", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if !isSignedIn {
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
                    else {
                        Button(action: {
                            keychain.delete("accessToken")
                        }) {
                            Label("Logout", image: "rectangle.portrait.and.arrow.forward")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
    
    struct StatisticsRow: View {
        let title: String
        let color: Color
        let value: Int
        
        var body: some View {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(value)")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(
                        Circle()
                            .fill(color)
                    )
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
            isSignedIn = true
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
