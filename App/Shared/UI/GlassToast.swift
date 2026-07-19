import SwiftUI

struct GlassToast: View {
    enum DisplayMode: Equatable {
        case alert
        case hud
        case banner

        fileprivate var alignment: Alignment {
            switch self {
            case .alert:
                .center

            case .hud:
                .top

            case .banner:
                .bottom
            }
        }

        fileprivate var edgeInsets: EdgeInsets {
            switch self {
            case .alert:
                EdgeInsets(
                    top: 24,
                    leading: 20,
                    bottom: 24,
                    trailing: 20
                )

            case .hud:
                EdgeInsets(
                    top: 12,
                    leading: 16,
                    bottom: 0,
                    trailing: 16
                )

            case .banner:
                EdgeInsets(
                    top: 0,
                    leading: 16,
                    bottom: 12,
                    trailing: 16
                )
            }
        }
    }

    enum ToastType {
        case regular
        case loading
        case systemImage(String, Color)
        case complete(Color)
        case error(Color)

        fileprivate var showsIcon: Bool {
            switch self {
            case .regular:
                false

            case .loading,
                 .systemImage,
                 .complete,
                 .error:
                true
            }
        }

        fileprivate var isLoading: Bool {
            if case .loading = self {
                return true
            }

            return false
        }

        fileprivate var preventsAutomaticDismissal: Bool {
            isLoading
        }
    }

    let displayMode: DisplayMode
    let type: ToastType
    let title: String?
    let subTitle: String?

    init(
        displayMode: DisplayMode = .alert,
        type: ToastType = .regular,
        title: String? = nil,
        subTitle: String? = nil
    ) {
        self.displayMode = displayMode
        self.type = type
        self.title = title
        self.subTitle = subTitle
    }

    var body: some View {
        switch displayMode {
        case .alert:
            alertContent

        case .hud, .banner:
            capsuleContent
        }
    }

    // MARK: Center Alert / Loading

    private var alertContent: some View {
        VStack(spacing: type.isLoading ? 12 : 14) {
            if type.showsIcon {
                icon
                    .frame(
                        width: type.isLoading ? 28 : 48,
                        height: type.isLoading ? 28 : 48
                    )
            }

            if title != nil || subTitle != nil {
                VStack(spacing: 4) {
                    if let title {
                        Text(title)
                            .font(
                                type.isLoading
                                ? .subheadline.weight(.medium)
                                : .headline
                            )
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(
                                horizontal: true,
                                vertical: false
                            )
                    }

                    if let subTitle {
                        Text(subTitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                }
            }
        }
        .padding(.horizontal, type.isLoading ? 16 : 22)
        .padding(.vertical, type.isLoading ? 18 : 22)
        .frame(
            minWidth: type.isLoading ? 96 : 160,
            minHeight: type.isLoading ? 106 : 140
        )
        .fixedSize(
            horizontal: type.isLoading,
            vertical: true
        )
        .toastGlassRoundedRectangle(
            cornerRadius: type.isLoading ? 24 : 30
        )
        .accessibilityElement(children: .combine)
    }

    // MARK: HUD / Banner Capsule

    private var capsuleContent: some View {
        HStack(spacing: 10) {
            if type.showsIcon {
                ZStack {
                    Circle()
                        .fill(iconBackground)

                    icon
                }
                .frame(width: 36, height: 36)
            }

            if title != nil || subTitle != nil {
                VStack(alignment: .leading, spacing: 1) {
                    if let title {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }

                    if let subTitle {
                        Text(subTitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
            }
        }
        .padding(.leading, type.showsIcon ? 8 : 16)
        .padding(.trailing, 16)
        .padding(.vertical, 8)
        .frame(minHeight: 52)
        .toastGlassCapsule()
        .accessibilityElement(children: .combine)
    }

    private var iconBackground: Color {
        switch type {
        case .regular:
            .clear

        case .loading:
            Color.primary.opacity(0.08)

        case let .systemImage(_, color),
             let .complete(color),
             let .error(color):
            color.opacity(0.14)
        }
    }

    @ViewBuilder
    private var icon: some View {
        switch type {
        case .regular:
            EmptyView()

        case .loading:
            ProgressView()
                .controlSize(.regular)
                .tint(.primary)

        case let .systemImage(name, color):
            Image(systemName: name)
                .font(
                    .system(
                        size: displayMode == .alert ? 28 : 17,
                        weight: .semibold
                    )
                )
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(color)

        case let .complete(color):
            Image(
                systemName: displayMode == .alert
                ? "checkmark.circle.fill"
                : "checkmark"
            )
            .font(
                .system(
                    size: displayMode == .alert ? 38 : 16,
                    weight: .bold
                )
            )
            .foregroundStyle(color)

        case let .error(color):
            Image(
                systemName: displayMode == .alert
                ? "xmark.circle.fill"
                : "xmark"
            )
            .font(
                .system(
                    size: displayMode == .alert ? 38 : 16,
                    weight: .bold
                )
            )
            .foregroundStyle(color)
        }
    }
}


// MARK: - Toast Modifier

private struct GlassToastModifier: ViewModifier {
    @Binding var isPresenting: Bool

    let duration: TimeInterval
    let tapToDismiss: Bool
    let toast: GlassToast
    let onTap: () -> Void
    let completion: () -> Void

    @State private var isVisible = false
    @State private var automaticDismissTask: Task<Void, Never>?
    @State private var completionTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: toast.displayMode.alignment) {
                toast
                    .padding(toast.displayMode.edgeInsets)
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(
                        isVisible
                        ? 1
                        : hiddenScale
                    )
                    .offset(
                        y: isVisible
                        ? 0
                        : hiddenOffset
                    )
                    .allowsHitTesting(isVisible)
                    .accessibilityHidden(!isVisible)
                    .zIndex(10_000)
                    .onTapGesture {
                        guard isVisible else {
                            return
                        }

                        onTap()

                        guard tapToDismiss else {
                            return
                        }

                        isPresenting = false
                    }
            }
            .onAppear {
                guard isPresenting else {
                    return
                }

                present()
            }
            .onChange(of: isPresenting) { _, newValue in
                if newValue {
                    present()
                } else {
                    dismiss()
                }
            }
            .onDisappear {
                cancelTasks()
            }
    }

    private var hiddenScale: CGFloat {
        switch toast.displayMode {
        case .alert:
            0.95

        case .hud, .banner:
            0.97
        }
    }

    private var hiddenOffset: CGFloat {
        switch toast.displayMode {
        case .alert:
            6

        case .hud:
            -14

        case .banner:
            14
        }
    }

    private var presentationAnimation: Animation {
        switch toast.displayMode {
        case .alert:
            .smooth(
                duration: 0.48,
                extraBounce: 0.03
            )

        case .hud, .banner:
            .smooth(
                duration: 0.46,
                extraBounce: 0.02
            )
        }
    }

    private var dismissalAnimation: Animation {
        .smooth(
            duration: 0.30,
            extraBounce: 0
        )
    }

    @MainActor
    private func present() {
        automaticDismissTask?.cancel()
        completionTask?.cancel()

        withAnimation(presentationAnimation) {
            isVisible = true
        }

        scheduleAutomaticDismissal()
    }

    @MainActor
    private func dismiss() {
        automaticDismissTask?.cancel()
        completionTask?.cancel()

        guard isVisible else {
            return
        }

        withAnimation(dismissalAnimation) {
            isVisible = false
        }

        completionTask = Task { @MainActor in
            do {
                try await Task.sleep(
                    for: .milliseconds(310)
                )
            } catch {
                return
            }

            guard !Task.isCancelled,
                  !isVisible,
                  !isPresenting else {
                return
            }

            completion()
        }
    }

    @MainActor
    private func scheduleAutomaticDismissal() {
        automaticDismissTask?.cancel()

        guard duration > 0,
              !toast.type.preventsAutomaticDismissal else {
            return
        }

        automaticDismissTask = Task { @MainActor in
            do {
                try await Task.sleep(
                    for: .seconds(duration)
                )
            } catch {
                return
            }

            guard !Task.isCancelled,
                  isPresenting,
                  isVisible else {
                return
            }

            isPresenting = false
        }
    }

    @MainActor
    private func cancelTasks() {
        automaticDismissTask?.cancel()
        completionTask?.cancel()
    }
}


// MARK: - Public View API

extension View {
    func toast(
        isPresenting: Binding<Bool>,
        duration: TimeInterval = 2,
        tapToDismiss: Bool = true,
        onTap: @escaping () -> Void = {},
        completion: @escaping () -> Void = {},
        alert: () -> GlassToast
    ) -> some View {
        modifier(
            GlassToastModifier(
                isPresenting: isPresenting,
                duration: duration,
                tapToDismiss: tapToDismiss,
                toast: alert(),
                onTap: onTap,
                completion: completion
            )
        )
    }
}


// MARK: - Glass Appearance

private extension View {
    @ViewBuilder
    func toastGlassCapsule() -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(
                .regular,
                in: Capsule()
            )
        } else {
            background(
                .ultraThinMaterial,
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .strokeBorder(
                        Color.white.opacity(0.16),
                        lineWidth: 0.5
                    )
            }
            .shadow(
                color: Color.black.opacity(0.12),
                radius: 14,
                y: 6
            )
        }
    }

    @ViewBuilder
    func toastGlassRoundedRectangle(
        cornerRadius: CGFloat
    ) -> some View {
        let shape = RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )

        if #available(iOS 26.0, *) {
            glassEffect(
                .regular,
                in: shape
            )
        } else {
            background(
                .ultraThinMaterial,
                in: shape
            )
            .overlay {
                shape
                    .strokeBorder(
                        Color.white.opacity(0.16),
                        lineWidth: 0.5
                    )
            }
            .shadow(
                color: Color.black.opacity(0.14),
                radius: 18,
                y: 8
            )
        }
    }
}
