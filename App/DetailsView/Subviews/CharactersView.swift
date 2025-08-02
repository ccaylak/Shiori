import SwiftUI

struct CharactersView: View {
    let characters: [Character]
    let mediaType: MediaType
    
    var body: some View {
        if !characters.isEmpty {
            VStack (alignment: .leading){
                
                NavigationLink(destination: CharactersListView(characters: characters, mediaType: mediaType)) {
                    LabelWithChevron(text: "Characters")
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(
                            mediaType == .anime
                            ? characters.sorted { ($0.favorites ?? 0) > ($1.favorites ?? 0) }
                                : characters,
                                id: \.id
                        ) { character in
                            VStack(alignment: .leading) {
                                AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                                    .frame(width: 72, height: 108)
                                    .cornerRadius(12)
                                    .showFullTitleContextMenu(character.metaData.formattedName)
                                    .strokedBorder()
                                
                                Text(character.metaData.formattedName)
                                    .font(.caption)
                                    .frame(width: 72, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollClipDisabled()
            }
        }
    }
}

private struct CharactersListView: View {
    let characters: [Character]
    let mediaType: MediaType
    @State private var searchText = ""
    
    @State private var mangaSortingOptions: String = "Role"
    @State private var animeSortingOptions: String = "Favorite"
    
    @State private var showRole = CharacterRole.all
    @State private var selectedLanguage = VoiceActorLanguage.japanese
    
    private var filteredCharacters: [Character] {
        var result = characters
        if !searchText.isEmpty {
            result = result.filter { $0.metaData.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch showRole {
        case .main:
            result = result.filter { $0.role.lowercased() == "main" }
        case .supporting:
            result = result.filter { $0.role.lowercased() == "supporting" }
        default:
            break
        }
        
        if mediaType == .anime {
            if selectedLanguage != .unknown {
                result = result.filter { character in
                    let matches = character.voiceActors?.contains(where: { voiceActor in
                        let lang = voiceActor.language.lowercased()
                        let isMatch = lang == selectedLanguage.rawValue
                        return isMatch
                    }) ?? false
                    return matches
                }
            }
        }

        
        if mediaType == .anime {
                switch animeSortingOptions {
                case "Name":
                    result = result.sorted { $0.metaData.name.localizedCompare($1.metaData.name) == .orderedAscending }
                case "Role":
                    result = result.sorted { $0.role.localizedCompare($1.role) == .orderedAscending }
                case "Favorite":
                    result = result.sorted { ($0.favorites ?? 0) > ($1.favorites ?? 0) }
                default:
                    break
                }
            } else {
                switch mangaSortingOptions {
                case "Name":
                    result = result.sorted { $0.metaData.name.localizedCompare($1.metaData.name) == .orderedAscending }
                case "Role":
                    result = result.sorted { $0.role.localizedCompare($1.role) == .orderedAscending }
                default:
                    break
                }
            }
        
        return result
    }
    
    private var availableLanguages: [VoiceActorLanguage] {
        let languages = characters
            .flatMap { $0.voiceActors ?? [] }
            .compactMap { $0.language }
            .map { VoiceActorLanguage(rawValue: $0.lowercased()) ?? .unknown }
            .filter { $0 != .unknown }
        
        return Array(Set(languages)).sorted()
    }
    
    
    var body: some View {
        List {
            ForEach(filteredCharacters, id: \.id) { character in
                HStack {
                    HStack {
                        AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                            .frame(width: 50, height: 78)
                            .cornerRadius(12)
                            .strokedBorder()
                        
                        VStack (alignment: .leading){
                            Text(character.metaData.formattedName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .font(.caption)
                                .bold()
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 2) {
                                if let role = CharacterRole(rawValue: character.role.lowercased()) {
                                    Image(systemName: role.icon)
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                }
                                if let role = CharacterRole(rawValue: character.role.lowercased()) {
                                    Text(role.displayName)
                                        .font(.caption)
                                }
                            }
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if mediaType == .anime {
                        HStack {
                            let matchingVA = character.voiceActors?.first(where: {
                                $0.language.lowercased() == selectedLanguage.rawValue
                            })

                            VStack {
                                Text(matchingVA?.person.formattedName ?? "Kein Sprecher")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .font(.caption)
                                    .bold()
                                Spacer()
                                Text(
                                    VoiceActorLanguage(rawValue: matchingVA?.language.lowercased() ?? "")?.displayName
                                    ?? "Unbekannt"
                                )
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            AsyncImageView(imageUrl: matchingVA?.person.images.jpg.imageUrl ?? "")
                                .frame(width: 50, height: 78)
                                .cornerRadius(12)
                                .strokedBorder()
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                }
                .frame(maxHeight: 78)
            }
        }
        .contentMargins(.top, 0)
        .listRowSpacing(10)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Picker(selection: $showRole, label: Text("Display options")) {
                        ForEach(CharacterRole.allCases, id: \.self) { role in
                            Label(role.displayName, systemImage: role.icon)
                                .tag(role)
                        }
                    }
                    
                    let sortingOptions = mediaType == .anime ? $animeSortingOptions : $mangaSortingOptions

                    Picker(selection: sortingOptions, label: Text("Sorting options")) {
                        if mediaType == .anime {
                            Label("Favorites", systemImage: "heart.fill")
                                .tag("Favorite")
                        }
                        Label("Role", systemImage: "person.crop.square.on.square.angled.fill")
                            .tag("Role")
                        Label("Name", systemImage: "textformat.characters")
                            .tag("Name")
                    }
                    
                    if mediaType == .anime {
                        Menu {
                            Picker(selection: $selectedLanguage, label: Text("Display options")) {
                                ForEach(availableLanguages, id: \.self) { language in
                                    Text(language.displayName)
                                        .tag(language)
                                }
                            }
                        } label : {
                            Label("Language", systemImage: "globe")
                        }
                    }
                    
                } label : {
                    Label("Sort", systemImage: "ellipsis")
                }
            }
        }
        .navigationTitle("Characters and voice actors")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search characters")
    }
}
