import SwiftUI

struct SearchView: View {
    
    @ObservedObject private var resultManager: ResultManager = .shared
    
    @State private var isOn = false
    
    var body: some View {
        NavigationStack {
            ResultView()
                .navigationTitle(resultManager.seriesType.rawValue.capitalized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    selectionMenu
                    sortMenu
                    if #available(iOS 26.0, *) {
                        ToolbarSpacer(.fixed)
                    }
                    exploreGenres
                }
        }
    }
    
    private var selectionMenu: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                resultManager.seriesType = (resultManager.seriesType == .manga) ? .anime : .manga
            } label: {
                Image(systemName: resultManager.seriesType == .manga ? "character.book.closed.ja" : "tv")
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(Color.accentColor)
                    .symbolRenderingMode(.monochrome)
            }
            .sensoryFeedback(.selection, trigger: resultManager.seriesType)
            .buttonStyle(.borderless)
        }
    }
    
    private var sortMenu: some ToolbarContent {
        ToolbarItem {
            Menu {
                if resultManager.seriesType == .anime {
                    animeSortPicker
                } else {
                    mangaSortPicker
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .fontWeight(.regular)
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    private var exploreGenres: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if (resultManager.seriesType == .manga) {
                NavigationLink(destination: GenreListView(mode: .manga)) {
                    Image(systemName: "square.stack")
                        .foregroundColor(.accentColor)
                }
            }
            
            if (resultManager.seriesType == .anime) {
                Menu {
                    NavigationLink(destination: GenreListView(mode: .anime)) {
                        Label("Explore Anime Genres", systemImage: "tag")
                    }
                    NavigationLink(destination: StudiosView()) {
                        Label("Explore Anime Studios", systemImage: "film")
                    }
                } label : {
                    Image(systemName: "square.stack")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }

    
    private var animeSortPicker: some View {
        Picker("Sort anime", selection: $resultManager.animeRankingType) {
            ForEach(SortType.Anime.allCases, id: \.self) { type in
                Label(type.displayName, systemImage: type.icon).tag(type)
            }
        }
    }
    
    private var mangaSortPicker: some View {
        Picker("Sort manga", selection: $resultManager.mangaRankingType) {
            ForEach(SortType.Manga.allCases, id: \.self) { type in
                Label(type.displayName, systemImage: type.icon)
                    .tag(type)
            }
        }
    }
}

#Preview {
    SearchView()
}
