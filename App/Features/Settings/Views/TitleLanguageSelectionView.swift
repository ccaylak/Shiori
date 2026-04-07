import SwiftUI

struct TitleLanguageSelectionView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    let animeController = AnimeController()
    
    @State var exampleAnime: MediaNode = MediaNode(id: 0, title: "", mainPicture: Picture(medium: ""))
    
    var body: some View {
        List {
            Section("Preview") {
                LibraryMediaView(
                    title: exampleAnime.preferredTitle,
                    image: exampleAnime.mainPicture.largeUrl,
                    release: exampleAnime.getStartSeason.seasonLabel,
                    type: exampleAnime.specificMediaType,
                    score: exampleAnime.getMyListStatus.score,
                    progress: LibraryMediaProgress(current: exampleAnime.getMyListStatus.watchedEpisodes, total: exampleAnime.episodes, secondaryCurrent: 0, secondaryTotal: 0),
                    episodeDurationInMinutes: exampleAnime.averageEpisodeDurationInMinutes
                )
            }
            Section {
                Picker("Title Language", systemImage: "circle.lefthalf.filled", selection: $settingsManager.titleLanguage) {
                    ForEach(TitleLanguage.allCases, id: \.self) { language in
                        Text(language.displayName).tag(language)
                    }
                }
                .pickerStyle(.navigationLink)
            } footer: {
                Text("Choose how Anime and Manga titles are displayed: Original, Romaji, or English.")
            }
        }
        .navigationTitle("Title Language")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                exampleAnime = try await animeController.fetchDetails(id: 53065)
            }
        }
    }
}
