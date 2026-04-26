import SwiftUI

struct OnboardingWelcomeView: View {
    
    let onNext: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(uiImage: UIImage(named: "AppIcon")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .strokedBorder()
                        
                Text("Welcome to Shiori!")
                    .font(.title)
                    .fontWeight(.semibold)
                        
                Text("Track your anime and manga, manage your library, and discover new favorites.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.center)
        .safeAreaInset(edge: .bottom) {
            Button {
                onNext()
            } label: {
                Text("Get Started")
                    .fontWeight(.bold)
            }
            .borderedProminentOrGlassProminent()
            .controlSize(.large)
            .buttonSizingFullWidth()
        }
    }
}
