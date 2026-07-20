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

extension Person {
    func preferredName(format: NameFormat) -> String {
        format.format(name)
    }
}

extension MetaData {
    func preferredName(format: NameFormat) -> String {
        format.format(name)
    }
}

extension NameFormat {
    func format(_ name: String) -> String {
        switch self {
        case .lastFirst:
            return name

        case .firstLast:
            let parts = name
                .split(separator: ",", maxSplits: 1)
                .map {
                    $0.trimmingCharacters(in: .whitespaces)
                }

            guard parts.count == 2 else {
                return name
            }

            return "\(parts[1]) \(parts[0])"
        }
    }
}
