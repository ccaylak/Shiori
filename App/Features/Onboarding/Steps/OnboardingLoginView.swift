import SwiftUI
import AuthenticationServices

struct OnboardingLoginView: View {
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @StateObject private var tokenHandler: TokenHandler = .shared
    
    @State private var isAuthenticating = false
    private let authService = MALAuthService.shared
    
    let onNext: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Let's get you set up")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Connect your MyAnimeList account to sync your library and track your progress.")
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.center)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {
                Button {
                    Task {
                        await loginWithMAL()
                    }
                } label: {
                    HStack(alignment: .center) {
                        Text("Continue with")
                        .fontWeight(.semibold)
                        
                        Image("mal_logo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.white)
                            .frame(height: 16)
                    }
                }
                .controlSize(.large)
                .borderedProminentOrGlassProminent()

                HStack(spacing: 12) {
                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                        .frame(height: 1)

                    Text("or")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                        .frame(height: 1)
                }
                .padding(.vertical, 8)

                VStack(spacing: 8) {
                    Button {
                        onNext()
                    } label: {
                        Text("Skip for now")
                    }
                    .controlSize(.regular)
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    .glassEffectOrMaterial()

                    Text("You can still connect your account later.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
    }
    
    private func loginWithMAL() async {
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
                
                onNext()
            } catch {
                print("Authentication failed: \(error)")
            }
        }
}
