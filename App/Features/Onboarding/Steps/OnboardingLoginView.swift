import SwiftUI
import AuthenticationServices

struct OnboardingLoginView: View {
    
    @Environment(\.webAuthenticationSession)
    private var webAuthenticationSession
    
    @Environment(AccountSession.self)
    private var accountSession
    
    @State private var viewModel = LoginViewModel()
    
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
                        await login(with: .myAnimeList)
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
                
                Button {
                    Task {
                        await login(with: .aniList)
                    }
                } label: {
                    HStack(alignment: .center) {
                        Text("Continue with")
                        .fontWeight(.semibold)
                        
                        Text("AniList")
                            .fontWeight(.bold)
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
            
                Button("Skip for now") {
                    onNext()
                }
                .buttonStyle(.bordered)
                .tint(.secondary)

                Text("You can still connect your account later.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
    
    private func login(with provider: AccountProvider) async {
            await viewModel.login(
                with: provider,
                session: accountSession,
                authenticate: authenticate
            )

            guard accountSession.isAuthenticated else {
                return
            }

            onNext()
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
}
