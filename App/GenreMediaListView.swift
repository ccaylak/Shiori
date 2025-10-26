import SwiftUI

struct GenreMediaListView: View {
    @State private var selectedOption = "Anime"
    let options = [MediaType.anime.displayName, MediaType.manga.displayName]
    var body: some View {
        NavigationStack {
            Picker("Optionen", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            ScrollView {
                VStack {
                    Text("")
                }
            }
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.automatic)
    }
}
