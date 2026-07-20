import SwiftUI

struct AnimeFormatSelectionView: View {
    @Environment(AppSettings.self)
    private var settings
    
    var body: some View {
        @Bindable var settings = settings
        
        List {
            Section(
                header: Text("Preview"),
                footer: Text("This preview is only meant to illustrate the selected format.")
            ) {
                LibraryMediaView(malId: 1, title: "Nana", image: "https://myanimelist.net/images/anime/2/11232l.jpg", release: "Spring 2006", type: .anime(.tv), score: 10, progress: LibraryMediaProgress(current: 5, total: 47, secondaryCurrent: 0, secondaryTotal: 0), episodeDurationInMinutes: 22, completed: false)
            }
            
            Section {
                Picker("Format", systemImage: SeriesType.anime.icon, selection: $settings.animeFormat) {
                   ForEach(AnimeFormat.allCases, id: \.self) { mode in
                       Text(mode.displayName)
                           .tag(mode)
                   }
                }
                .pickerStyle(.navigationLink)
                Toggle("First episode counts toward duration", isOn: $settings.includeFirstEpisodeInDuration)
                    .toggleStyle(.switch)
                    .isVisible(settings.animeFormat == .episodesWithDuration)
            } footer: {
                Text(settings.animeFormat.description)
            }
        }
        .navigationTitle("Anime Progress Format")
        .toolbarTitleDisplayMode(.inline)
    }
}
