import SwiftUI
import TelemetryDeck

struct SearchView: View {
    @Environment(ResultSettings.self)
    private var resultSettings

    @Environment(AppSettings.self)
    private var settings

    var body: some View {
        NavigationStack {
            ResultView()
                .navigationTitle(resultSettings.seriesType.displayName)
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
                resultSettings.seriesType =
                    resultSettings.seriesType == .manga
                    ? .anime
                    : .manga
            } label: {
                Image(
                    systemName: resultSettings.seriesType == .manga
                    ? "character.book.closed.ja"
                    : "tv"
                )
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(.tint)
                .symbolRenderingMode(.monochrome)
            }
            .sensoryFeedback(
                .selection,
                trigger: resultSettings.seriesType
            )
            .buttonStyle(.borderless)
        }
    }

    private var sortMenu: some ToolbarContent {
        ToolbarItem {
            Menu {
                if resultSettings.seriesType == .anime {
                    animeSortPicker
                } else {
                    mangaSortPicker
                }
            } label: {
                Image(
                    systemName: resultSettings.seriesType == .anime
                    ? resultSettings.animeRankingType.icon
                    : resultSettings.mangaRankingType.icon
                )
                .fontWeight(.regular)
                .foregroundStyle(.tint)
            }
        }
    }

    private var exploreGenres: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if settings.isExtendedDataEnabled {
                if resultSettings.seriesType == .manga {
                    NavigationLink {
                        GenreListView(mode: .manga)
                            .trackNavigation(path: "genres")
                    } label: {
                        Image(systemName: "square.stack")
                            .foregroundStyle(.tint)
                    }
                } else {
                    Menu {
                        NavigationLink {
                            GenreListView(mode: .anime)
                                .trackNavigation(path: "genres")
                        } label: {
                            Label(
                                "Explore Anime Genres",
                                systemImage: "tag"
                            )
                        }

                        NavigationLink {
                            StudiosView()
                                .trackNavigation(path: "studios")
                        } label: {
                            Label(
                                "Explore Anime Studios",
                                systemImage: "film"
                            )
                        }
                    } label: {
                        Image(systemName: "square.stack")
                            .foregroundStyle(.tint)
                    }
                }
            }
        }
    }

    private var animeSortPicker: some View {
        Picker(
            "Sort anime",
            selection: Binding(
                get: {
                    resultSettings.animeRankingType
                },
                set: {
                    resultSettings.animeRankingType = $0
                }
            )
        ) {
            ForEach(SortType.Anime.allCases, id: \.self) { type in
                Label(
                    type.displayName,
                    systemImage: type.icon
                )
                .tag(type)
            }
        }
    }

    private var mangaSortPicker: some View {
        Picker(
            "Sort manga",
            selection: Binding(
                get: {
                    resultSettings.mangaRankingType
                },
                set: {
                    resultSettings.mangaRankingType = $0
                }
            )
        ) {
            ForEach(SortType.Manga.allCases, id: \.self) { type in
                Label(
                    type.displayName,
                    systemImage: type.icon
                )
                .tag(type)
            }
        }
    }
}

#Preview {
    SearchView()
        .environment(AppSettings())
        .environment(ResultSettings())
        .environment(ToastManager())
}
