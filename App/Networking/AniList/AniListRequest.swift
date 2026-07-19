import Foundation

struct AniListRequest<Variables: Encodable>: Encodable {
    let query: String
    let variables: Variables
}

struct AiringVariables: Encodable {
    let malIds: [Int]
    let page: Int
}
