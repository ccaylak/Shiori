import Foundation

struct JikanFriends: Decodable, Hashable {
    let data: [JikanFriendsData]
}

struct JikanFriendsData: Decodable, Hashable {
    let user: JikanUser
}

struct JikanUser: Decodable, Hashable {
    let username: String
    let images: UserImages
}

struct UserImages: Decodable, Hashable {
    let jpg: UserJPG
}

struct UserJPG: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
    let imageUrl: String?
}
