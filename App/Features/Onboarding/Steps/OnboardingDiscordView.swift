import SwiftUI

struct OnboardingDiscordView: View {
    
    @Environment(\.openURL) private var openURL
    let onNext: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Join the Shiori Discord")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Get updates, share feedback, report bugs and talk with other Shiori users.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .defaultScrollAnchor(.center)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {
                Button {
                    if let url = URL(string: "https://discord.gg/4ajqv3aMdd") {
                        openURL(url)
                        onNext()
                    }
                } label: {
                    HStack {
                        Text("Join Shiori on")
                            .fontWeight(.semibold)
                        Image("discord_logo")
                            .resizable()
                            .scaledToFit()
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

                    Text("You can join anytime later from Settings.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
    }
}
