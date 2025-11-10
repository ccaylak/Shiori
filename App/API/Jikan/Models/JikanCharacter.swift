import Foundation

struct JikanCharacter: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: [Character]
}

struct Character: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case role, favorites
        case metaData = "character"
        case voiceActors = "voice_actors"
    }
    
    let id: String = UUID().uuidString
    let role: String
    let favorites: Int?
    let metaData: MetaData
    let voiceActors: [VoiceActor]?
    
    init(role: String = "", favorites: Int? = nil, metaData: MetaData, voiceActors: [VoiceActor]? = nil) {
        self.role = role
        self.favorites = favorites
        self.metaData = metaData
        self.voiceActors = voiceActors
    }
}

struct MetaData: Decodable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case images, name
    }
    
    let malId: Int
    let name: String
    let images: CharacterImage
}

struct VoiceActor: Decodable {
    enum CodingKeys: String, CodingKey {
        case person, language
    }
    
    let person: Person
    let language: String
}

struct Person: Decodable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case url, name, images
    }
    
    let malId: Int
    let url: String
    let name: String
    let images: CharacterImage
}

struct CharacterImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case jpg
    }
    
    let jpg: CharacterJPG
}

struct CharacterJPG: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
    
    let imageUrl: String
}

@MainActor
extension Person {
    var formattedName: String {
        let nameFormat = SettingsManager.shared.namePresentation
        
        switch nameFormat {
        case .lastFirst:
            return name
            
        case .firstLast:
            let parts = name.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else {
                return name
            }
            return "\(parts[1]) \(parts[0])"
        }
    }
}

@MainActor
extension MetaData {
    var formattedName: String {
        let nameFormat = SettingsManager.shared.namePresentation
        
        switch nameFormat {
        case .lastFirst:
            return name
            
        case .firstLast:
            let parts = name.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else {
                return name
            }
            return "\(parts[1]) \(parts[0])"
        }
    }
}
