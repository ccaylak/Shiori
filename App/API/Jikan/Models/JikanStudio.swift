import Foundation

struct JikanStudio: Decodable {
    
    private(set) var data: [JikanStudioData]
    private(set) var pagination: JikanPagination?
    
    mutating func append(_ newData: [JikanStudioData]) {
        data.append(contentsOf: newData)
    }
}

struct JikanAnimeStudioResponse: Decodable {
    
    private(set) var data: JikanStudioData
}

struct JikanStudioData: Decodable {
    
    private(set) var malId: Int
    private(set) var url: String
    private(set) var favorites: Int
    private(set) var titles: [JikanTitle]
    private(set) var images: JikanImages
    private(set) var count: Int
    private(set) var established: String?
    private(set) var about: String?
}

extension JikanStudioData {
    var aboutText: String {
        about ?? "No studio description available"
    }
}
