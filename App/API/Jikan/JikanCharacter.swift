import Foundation

struct JikanCharacter: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: [Character]
}

struct Character: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case role
        case metaData = "character"
    }
    
    let id: String = UUID().uuidString
    let role: String
    let metaData: MetaData
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
