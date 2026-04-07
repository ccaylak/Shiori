import SwiftUI

struct PillPicker<T: Hashable>: View {
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @Environment(\.colorScheme) private var colorScheme
    let options: [T]
    @Binding var selectedOption: T
    let displayName: (T) -> String
    let icon: (T) -> AnyView
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    let isSelected = (option == selectedOption)
                    
                    if #available(iOS 26.0, *) {
                        Button {
                            withAnimation(.snappy) {
                                selectedOption = option
                            }
                        } label: {
                            Label {
                                Text(displayName(option))
                                    .fontWeight(.medium)
                                    .font(.body)
                            } icon: {
                                icon(option)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .contentShape(.capsule)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(.regular.interactive(), in: .capsule)
                        .shadow(
                            color: isSelected ? Color.accentColor.opacity(0.8) : .clear,
                            radius: 4,
                            x: 0,
                            y: 0
                        )
                        
                    } else {
                        Button {
                            withAnimation {
                                selectedOption = option
                            }
                        } label: {
                            Label {
                                Text(displayName(option))
                                    .fontWeight(.medium)
                                    .font(.body)
                            } icon: {
                                icon(option)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        isSelected
                                        ? Color.accentColor
                                        : Color.clear,
                                        lineWidth: 5
                                    )
                            )
                            .cornerRadius(8)
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal)
        }
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
