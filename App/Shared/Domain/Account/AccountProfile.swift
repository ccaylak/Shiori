import Foundation

struct AccountProfile {
    let id: String
    let provider: AccountProvider
    let username: String

    let avatarURL: String?
    let profileURL: String?

    let birthday: Date?
    let joinedAt: Date?

    let location: String?
    let gender: String?
}
