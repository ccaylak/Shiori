import Foundation

struct ProfileDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, gender, location
        case profilePicture = "picture"
        case birthDate = "birthday"
        case joinDate = "joined_at"
        case timeZone = "time_zone"
    }
    
    let id: Int
    let name: String
    let profilePicture: String?
    let gender: String?
    let birthDate: String?
    let location: String?
    let joinDate: String?
    let timeZone: String?
    
    init(id: Int, name: String, profilePicture: String? = nil, gender: String? = nil, birthDate: String? = nil, location: String? = nil, joinDate: String? = nil, timeZone: String? = nil) {
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
        self.gender = gender
        self.birthDate = birthDate
        self.location = location
        self.joinDate = joinDate
        self.timeZone = timeZone
    }
}
