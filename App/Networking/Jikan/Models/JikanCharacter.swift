import Foundation

struct JikanCharacter: Decodable {
    
    private(set) var data: [CharacterData]
}

struct CharacterData: Decodable, Identifiable {
    
    var id: Int {character.malId}
    private(set) var role: String
    private(set) var favorites: Int?
    private(set) var character: MetaData
    private(set) var voiceActors: [VoiceActor]?
}

struct MetaData: Decodable {
    
    private(set) var malId: Int
    private(set) var name: String
    private(set) var images: JikanImages
}

struct VoiceActor: Decodable {
    
    private(set) var person: Person
    private(set) var language: String
}

struct Person: Decodable {
    
    private(set) var malId: Int
    private(set) var name: String
    private(set) var images: JikanImages
}

@MainActor
extension Person {
    var preferredNameFormat: String {
        let nameFormat = SettingsManager.shared.nameFormat
        
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
    var preferredNameFormat: String {
        let nameFormat = SettingsManager.shared.nameFormat
        
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
