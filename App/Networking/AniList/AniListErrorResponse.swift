struct AniListErrorResponse: Decodable {
    let errors: [AniListError]
}

struct AniListError: Decodable {
    let message: String
    let status: Int?
}
