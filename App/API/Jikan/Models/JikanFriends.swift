import Foundation

struct JikanFriends: Decodable {
    private(set) var data: [JikanFriendsData]
}

struct JikanFriendsData: Decodable {
    private(set) var user: JikanUser
}

struct JikanUser: Decodable {
    private(set) var username: String
    private(set) var images: JikanImages
}
