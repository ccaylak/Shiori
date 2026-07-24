import SwiftUI

struct TitleLanguageSelectionView: View {
    @Environment(MALDependencies.self)
    private var malDependencies
    
    @Environment(AppSettings.self)
    private var settings
    
    @State var exampleAnime: MediaNode = MediaNode(id: 0, title: "", mainPicture: Picture(medium: ""))
    
    var body: some View {
        @Bindable
        var settings = settings
        
        List {
            Section("Preview") {
                LibraryMediaView(
                    malId: exampleAnime.id,
                    title: exampleAnime.preferredTitle,
                    image: exampleAnime.mainPicture.largeUrl,
                    release: exampleAnime.getStartSeason.seasonLabel,
                    type: exampleAnime.specificMediaType,
                    score: exampleAnime.getMyListStatus.score,
                    progress: LibraryMediaProgress(current: exampleAnime.getMyListStatus.watchedEpisodes, total: exampleAnime.episodes, secondaryCurrent: 0, secondaryTotal: 0),
                    episodeDurationInMinutes: exampleAnime.averageEpisodeDurationInMinutes,
                    completed: false
                )
            }
            Section {
                Picker("Title Language", systemImage: "circle.lefthalf.filled", selection: $settings.titleLanguage) {
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
        .task {
            do {
                exampleAnime = try await malDependencies.animeController
                    .fetchDetails(id: 53065)
            } catch {
                print("Failed to load example anime:", error)
            }
        }
    }
}
