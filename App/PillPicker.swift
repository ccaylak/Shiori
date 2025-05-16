import SwiftUI

struct PillPicker<T: Hashable>: View {
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    let options: [T]
    @Binding var selectedOption: T
    let displayName: (T) -> String
    let icon: (T) -> AnyView
    
    private var isDarkMode: Bool {
        if settingsManager.appearance == .system {
            return colorScheme == .dark
        }
        return settingsManager.appearance == .dark
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Label {
                        Text(displayName(option))
                            .fontWeight(.medium)
                            .font(.body)
                            .foregroundStyle(selectedOption == option ? Color.white : Color.primary)
                    } icon: {
                        icon(option)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(selectedOption == option ? Color.getByColorString(settingsManager.accentColor.rawValue) : isDarkMode ? Color.gray.opacity(0.15) : Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                    .onTapGesture {
                        selectedOption = option
                    }
                }
            }
        }
        .scrollClipDisabled()
    }
}

#Preview {
    @Previewable @State var mangaStatus: ProgressStatus.Manga = .completed
    PillPicker(
        options: ProgressStatus.Manga.allCases,
        selectedOption: $mangaStatus,
        displayName: { $0.displayName },
        icon: { AnyView($0.libraryIcon) }
    )
}
