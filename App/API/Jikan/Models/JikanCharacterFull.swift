import Foundation

struct JikanCharacterFull: Decodable {
    
    private(set) var data: CharacterDetails
}

struct CharacterDetails: Decodable {
    
    private(set) var malId: Int
    private(set) var url: String
    private(set) var images: JikanImages
    private(set) var name: String
    private(set) var nameKanji: String?
    private(set) var nicknames: [String]
    private(set) var favorites: Int
    private(set) var about: String?
    private(set) var anime: [CharacterDetailsMedia]
    private(set) var manga: [CharacterDetailsMedia]
    private(set) var voices: [VoiceActor]
}

struct CharacterDetailsMedia: Decodable {
    
    private(set) var role: String
    private(set) var anime: FavoriteEntry?
    private(set) var manga: FavoriteEntry?
}
