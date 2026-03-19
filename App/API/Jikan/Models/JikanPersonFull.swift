import Foundation

struct JikanPerson: Decodable {
    
    private(set) var data: JikanPersonData
}

struct JikanPersonData: Decodable {
    
    private(set) var malId: Int
    private(set) var websiteUrl: String?
    private(set) var url: String
    private(set) var images: JikanImages
    private(set) var name: String
    private(set) var givenName: String?
    private(set) var familyName: String?
    private(set) var alternateNames: [String]
    private(set) var birthday: String?
    private(set) var favorites: Int
    private(set) var about: String?
    private(set) var voices: [PersonVoice]
}

struct PersonVoice: Decodable {
    
    private(set) var role: String
    private(set) var anime: FavoriteEntry
    private(set) var character: FavoriteEntry
}
