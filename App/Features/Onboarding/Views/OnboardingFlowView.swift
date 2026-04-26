import SwiftUI

struct OnboardingFlowView: View {
    
    @Binding var isPresented: Bool
    @State private var currentStep: OnboardingStep = .welcome
    @AppStorage("shouldShowOnboarding") private var shouldShowOnboarding: Bool = false
    
    private let steps = OnboardingStep.allCases
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                currentView
                    .id(currentStep)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .animation(.smooth, value: currentStep)

            HStack(spacing: 6) {
                ForEach(steps, id: \.self) { step in
                    Capsule()
                        .fill(step == currentStep ? Color.accentColor : .secondary.opacity(0.25))
                        .frame(width: step == currentStep ? 18 : 7, height: 7)
                }
            }
            .padding(.top, 16)
            .animation(.smooth, value: currentStep)
        }
    }
    
    @ViewBuilder
    private var currentView: some View {
        switch currentStep {
        case .welcome:
            OnboardingWelcomeView {
                withAnimation(.smooth) {
                    currentStep = .login
                }
            }
            
        case .login:
            OnboardingLoginView {
                withAnimation(.smooth) {
                    currentStep = .discord
                }
            }
            
        case .discord:
            OnboardingDiscordView {
                shouldShowOnboarding = false
                isPresented = false
            }
        }
    }
}
