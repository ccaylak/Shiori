import SwiftUI

struct EditDetailsView: View {
    var body: some View {
        List {
            Section(footer: Text("You can choose which sections of an anime or manga to show or hide.")) {
                ForEach(EditSections.allCases, id: \.self) { section in
                    section.toggleComponent
                }
            }
        }
        .navigationTitle("Sections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditDetailsView()
}
