import SwiftUI

struct PillPicker<T: Hashable>: View {
    @ObservedObject private var settingsManager: SettingsManager = .shared
    let options: [T]
    @Binding var selectedOption: T
    let displayName: (T) -> String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(options, id: \.self) { option in
                    Text(displayName(option))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(selectedOption == option ? Color.getByColorString(settingsManager.accentColor.rawValue) : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .onTapGesture {
                            selectedOption = option
                        }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var mangaStatus: MangaProgressStatus = .completed
    PillPicker(options: MangaProgressStatus.allCases, selectedOption: $mangaStatus, displayName: { $0.displayName })
}
