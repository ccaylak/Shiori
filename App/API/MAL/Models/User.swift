import Foundation

struct User: Decodable {
    
    private(set) var id: Int
    private(set) var name: String
    private(set) var picture: String?
    private(set) var gender: String?
    private(set) var birthday: String?
    private(set) var location: String?
    private(set) var joinedAt: String?
    private(set) var timeZone: String?
}

extension User {
    var pictureUrl: String {
        picture ?? "https://upload.wikimedia.org/wikipedia/commons/7/7a/MyAnimeList_Logo.png"
    }
    
    var genderType: Gender {
        Gender(rawValue: gender?.lowercased() ?? "") ?? .unknown
    }
    
    var locationText: String {
        location ?? "Unknown location"
    }
    
    var joinedAtText: String {
        joinedAt ?? "Unknown join date"
    }
    
    var timeZoneText: String {
        timeZone ?? "Unknown time zone"
    }
}
