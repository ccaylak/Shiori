import SwiftUI

struct SearchView: View {
    
    @ObservedObject private var resultManager: ResultManager = .shared
    
    @State private var isOn = false
    
    var body: some View {
        NavigationStack {
            ResultView()
                .navigationTitle(resultManager.mediaType.rawValue.capitalized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    selectionMenu
                    sortMenu
                }
        }
    }
    
    private var selectionMenu: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                resultManager.mediaType = (resultManager.mediaType == .manga) ? .anime : .manga
            } label: {
                Image(systemName: resultManager.mediaType == .manga ? "character.book.closed.ja" : "tv")
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(Color.accentColor)
                    .symbolRenderingMode(.monochrome)
            }
            .sensoryFeedback(.selection, trigger: resultManager.mediaType)
            .buttonStyle(.borderless)
        }
    }
    
    
    private var sortMenu: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Text("Sort by")
                if resultManager.mediaType == .anime {
                    animeSortPicker
                } else {
                    mangaSortPicker
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .fontWeight(.regular)
            }
        }
    }
    
    private var animeSortPicker: some View {
        Picker("Sort by", selection: $resultManager.animeRankingType) {
            ForEach(SortType.Anime.allCases, id: \.self) { type in
                Label(type.displayName, systemImage: type.icon).tag(type)
            }
        }
    }
    
    private var mangaSortPicker: some View {
        Picker("Sort by", selection: $resultManager.mangaRankingType) {
            ForEach(SortType.Manga.allCases, id: \.self) { type in
                Text(type.displayName).tag(type)
            }
        }
    }
}

#Preview {
    SearchView()
}
