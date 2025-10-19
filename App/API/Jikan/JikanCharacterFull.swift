import Foundation

struct JikanCharacterFull: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: CharacterDetails
}

struct CharacterDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case url, images, name
        case nameKanji = "name_kanji"
        case nicknames, favorites, about, voices
        case animeAppearances = "anime"
        case mangaAppearances = "manga"
    }
    
    let malId: Int
    let url: String
    let images: CharacterImage
    let name: String
    let nameKanji: String
    let nicknames: [String]
    let favorites: Int
    let about: String
    let animeAppearances: [CharacterDetailsAnime]
    let mangaAppearances: [CharacterDetailsManga]
    let voices: [VoiceActor]
}

struct CharacterDetailsAnime: Decodable {
    enum CodingKeys: String, CodingKey {
        case role, anime
    }
    
    let role: String
    let anime: FavoriteEntries
}

struct CharacterDetailsManga: Decodable {
    enum CodingKeys: String, CodingKey {
        case role, manga
    }
    
    let role: String
    let manga: FavoriteEntries
}
