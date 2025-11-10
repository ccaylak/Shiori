import Foundation

struct JikanPersonFull: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: PersonDetails
}

struct PersonDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case websiteUrl = "website_url"
        case images, name
        case givenName = "given_name"
        case familyName = "family_name"
        case alternateNames = "alternate_names"
        case birthday, favorites, about, voices, url
    }
    
    let malId: Int
    let websiteUrl: String?
    let url: String
    let images: CharacterImage
    let name: String
    let givenName: String?
    let familyName: String?
    let alternateNames: [String]
    let birthday: String?
    let favorites: Int
    let about: String?
    let voices: [PersonVoice]
}

struct PersonVoice: Decodable {
    enum CodingKeys: String, CodingKey {
        case role, anime, character
    }
    
    let id = UUID()
    let role: String
    let anime: FavoriteEntries
    let character: FavoriteEntries
}
