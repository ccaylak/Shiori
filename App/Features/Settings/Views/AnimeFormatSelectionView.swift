import SwiftUI

struct AnimeFormatSelectionView: View {
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    var body: some View {
        List {
            Section(
                header: Text("Preview"),
                footer: Text("This preview is only meant to illustrate the selected format.")
            ) {
                LibraryMediaView(title: "Nana", image: "https://myanimelist.net/images/anime/2/11232l.jpg", release: "Spring 2006", type: .anime(.tv), score: 10, progress: LibraryMediaProgress(current: 5, total: 47, secondaryCurrent: 0, secondaryTotal: 0), episodeDurationInMinutes: 22)
            }
            
            Section {
                Picker("Format", systemImage: SeriesType.anime.icon, selection: $settingsManager.animeFormat) {
                   ForEach(AnimeFormat.allCases, id: \.self) { mode in
                       Text(mode.displayName)
                           .tag(mode)
                   }
                }
                .pickerStyle(.navigationLink)
                Toggle("First episode counts toward duration", isOn: $settingsManager.includeFirstEpisodeInDuration)
                    .toggleStyle(.switch)
                    .isVisible(settingsManager.animeFormat == .episodesWithDuration)
            } footer: {
                Text(settingsManager.animeFormat.description)
            }
        }
        .navigationTitle("Anime Progress Format")
        .toolbarTitleDisplayMode(.inline)
    }
}
