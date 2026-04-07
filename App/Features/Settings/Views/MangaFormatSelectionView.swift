import SwiftUI

struct MangaProgressFormatSelectionView: View {
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    var body: some View {
        List {
            Section(
                header: Text("Preview"),
                footer: Text("This preview is only meant to illustrate the selected format.")
            ) {
                LibraryMediaView(title: "Nana", image: "https://myanimelist.net/images/manga/1/262324l.webp", release: "2000", type: .manga(.manga), score: 9, progress: LibraryMediaProgress(current: 10, total: 200, secondaryCurrent: 0, secondaryTotal: 0), episodeDurationInMinutes: 0)
            }
            
            Section(
                footer: Text(settingsManager.mangaFormat.description)
            ) {
                Picker("Format", systemImage: SeriesType.manga.icon, selection: $settingsManager.mangaFormat) {
                   ForEach(MangaFormat.allCases, id: \.self) { mode in
                       Text(mode.displayName)
                           .tag(mode)
                   }
                }
                .pickerStyle(.navigationLink)
            }
        }
        .navigationTitle("Manga Progress Format")
        .toolbarTitleDisplayMode(.inline)
    }
}
