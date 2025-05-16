import SwiftUI

struct CharactersView: View {
    let characters: [Character]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading){
                NavigationLink(destination: CharactersListView(characters: characters)) {
                    HStack {
                        Text("Characters")
                            .font(.headline)
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(characters, id: \.id) { character in
                            VStack(alignment: .leading) {
                                AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                                    .frame(width: 60, height: 90)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                                Text(character.metaData.name)
                                    .font(.caption)
                                    .frame(width: 60, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                }
                .scrollClipDisabled()
            }
        }
    }
}

private struct CharactersListView: View {
    let characters: [Character]
    @State private var searchText = ""
    @State private var sortingOptiongs = "Role"
    @State private var showRole = "All"
    
    private var filteredCharacters: [Character] {
            
            var result = characters
            if !searchText.isEmpty {
                result = result.filter { $0.metaData.name.localizedCaseInsensitiveContains(searchText) }
            }

            switch showRole {
            case "Main":
                result = result.filter { $0.role.lowercased() == "main" }
            case "Supporting":
                result = result.filter { $0.role.lowercased() == "supporting" }
            default:
                break
            }

            switch sortingOptiongs {
            case "Name":
                result = result.sorted { $0.metaData.name.localizedCompare($1.metaData.name) == .orderedAscending }
            case "Role":
                result = result.sorted { $0.role.localizedCompare($1.role) == .orderedAscending }
            default:
                break
            }

            return result
        }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                ForEach(filteredCharacters, id: \.id) { character in
                    VStack {
                        AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                            .frame(width: 100, height: 156)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 5)
                            .overlay(alignment: .bottom) {
                                Text(character.role)
                                    .font(.caption2).bold()
                                    .foregroundStyle(.primary)
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        UnevenRoundedRectangle(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .blur(radius: 5)
                                    )
                                    .clipShape(
                                        UnevenRoundedRectangle(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
                                    )
                            }
                        
                        VStack (alignment: .leading){
                            Text(character.metaData.name)
                                .frame(width: 100, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.caption)
                                .bold()
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu{
                        Picker(selection: $showRole, label: Text("Display options")) {
                            Label("All", systemImage: "person.3.fill")
                                .tag("All")
                            Label("Main", systemImage: "person.2.fill")
                                .tag("Main")
                            Label("Supporting", systemImage: "person.fill")
                                .tag("Supporting")
                        }
                        
                        Picker(selection: $sortingOptiongs, label: Text("Sorting options")) {
                            Label("Role", systemImage: "person.crop.square.on.square.angled.fill")
                                .tag("Role")
                            Label("Name", systemImage: "textformat.characters")
                                .tag("Name")
                        }
                    } label : {
                        Label("Sort", systemImage: "ellipsis")
                    }
                }
            }
        }
        .navigationTitle("Characters")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search characters")
    }
}
