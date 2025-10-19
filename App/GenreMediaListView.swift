import SwiftUI

struct GenreMediaListView: View {
    @State private var selectedOption = "Anime"
    let options = ["Anime", "Manga"]
    var body: some View {
        NavigationStack {
            Picker("Optionen", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // wichtig für Toolbar
            .padding(.horizontal)
            
            ScrollView {
                VStack {
                    
                }
            }
        }
        .navigationTitle("Entdecken")
        .navigationBarTitleDisplayMode(.automatic)
    }
}
