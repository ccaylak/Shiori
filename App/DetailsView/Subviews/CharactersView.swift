import SwiftUI

struct CharactersView: View {
    let characters: [Character]
    let mediaType: MediaType
    
    var body: some View {
        if !characters.isEmpty {
            VStack (alignment: .leading, spacing: 5) {
                
                //NavigationLink(destination: CharactersListView(characters: characters, mediaType: mediaType)) {
                    LabelWithChevron(text: "Characters")
                        .padding(.horizontal)
                //}
                //.buttonStyle(.plain)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(
                            mediaType == .anime
                            ? characters.sorted { ($0.favorites ?? 0) > ($1.favorites ?? 0) }
                            : characters,
                            id: \.id
                        ) { character in
                            NavigationLink(destination: CharacterDetailsView(character: character, role: character.role)) {
                                VStack(alignment: .leading) {
                                    AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                                        .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                        .cornerRadius(12)
                                        .showFullTitleContextMenu(character.metaData.formattedName)
                                        .strokedBorder()
                                    
                                    Text(character.metaData.formattedName)
                                        .font(.caption)
                                        .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollClipDisabled()
            }
            .padding(.bottom)
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
    
    @State private var selectedCharacter: Character?
    @State private var selectedVoiceActorName: String?
    @State private var selectedVoiceActorImageURL: String?
    @State private var selectedVoiceActorLanguage: String?
    @State private var selectedVoiceActorId: Int?
    @State private var selectedDestination: CharacterVoiceActorRow.Destination?
    
    var body: some View {
        List(filteredCharacters, id: \.id) { character in
            CharacterVoiceActorRow(
                character: character,
                mediaType: mediaType,
                selectedLanguage: selectedLanguage.rawValue,
                onSelectDestination: { dest in
                    if dest == .character {
                        selectedCharacter = character
                    }
                    if dest == .voiceActor,
                       let matchingVA = character.voiceActors?.first(where: {
                           $0.language.lowercased() == selectedLanguage.rawValue.lowercased()
                       }) {
                        selectedVoiceActorName = matchingVA.person.formattedName
                        selectedVoiceActorImageURL = matchingVA.person.images.jpg.imageUrl
                        selectedVoiceActorLanguage = matchingVA.language
                        selectedVoiceActorId = matchingVA.person.malId
                    }
                    selectedDestination = dest
                }
            )
        }
        .navigationDestination(item: $selectedDestination) { destination in
                switch destination {
                case .character:
                    if let selectedCharacter {
                        CharacterDetailsView(
                            character: selectedCharacter,
                            role: CharacterRole(rawValue: selectedCharacter.role.lowercased())?.displayName ?? "Unbekannt"
                        )
                    }
                case .voiceActor:
                    if let id = selectedVoiceActorId,
                       let image = selectedVoiceActorImageURL,
                       let name = selectedVoiceActorName,
                       let language = selectedVoiceActorLanguage {
                        VoiceActorDetailsView(
                            id: id,
                            language: language,
                            image: image,
                            name: name
                        )
                    }
                }
            }
        .contentMargins(.top, 0)
        .listRowSpacing(10)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Menu {
                        Picker(selection: $showRole, label: Text("Display options")) {
                            ForEach(CharacterRole.allCases, id: \.self) { role in
                                Label(role.displayName, systemImage: role.icon)
                                    .tag(role)
                            }
                        }
                    } label: {
                        Label("Role", systemImage: "person.crop.rectangle")
                    }
                    
                    let sortingOptions = mediaType == .anime ? $animeSortingOptions : $mangaSortingOptions
                    
                    Menu {
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
                    } label : {
                        Label("Sort by", systemImage: "arrow.up.arrow.down")
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

private struct CharacterVoiceActorRow: View {
    let character: Character
    let mediaType: MediaType
    let selectedLanguage: String
    let onSelectDestination: (Destination) -> Void
    
    enum Destination: Hashable {
        case character
        case voiceActor
    }
    
    var body: some View {
        HStack {
            HStack {
                AsyncImageView(imageUrl: character.metaData.images.jpg.imageUrl)
                    .frame(width: 50, height: 78)
                    .cornerRadius(12)
                    .strokedBorder()
                
                VStack(alignment: .leading) {
                    Text(character.metaData.formattedName)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .font(.caption)
                        .bold()
                    Spacer()
                    HStack(spacing: 2) {
                        if let role = CharacterRole(rawValue: character.role.lowercased()) {
                            Image(systemName: role.icon)
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                            Text(role.displayName)
                                .font(.caption)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                onSelectDestination(.character)
            }
            
            if mediaType == .anime,
               let matchingVA = character.voiceActors?.first(where: {
                   return $0.language.lowercased() == selectedLanguage.lowercased()
               }) {
                HStack {
                    VStack {
                        Text(matchingVA.person.formattedName)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .font(.caption)
                            .bold()
                        Spacer()
                        Text(
                            VoiceActorLanguage(rawValue: matchingVA.language.lowercased())?.displayName ?? "Unbekannt"
                        )
                        .font(.caption)
                    }
                    AsyncImageView(imageUrl: matchingVA.person.images.jpg.imageUrl)
                        .frame(width: 50, height: 78)
                        .cornerRadius(12)
                        .strokedBorder()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    onSelectDestination(.voiceActor)
                }
            }
        }
        .frame(maxHeight: 78)
    }
}
