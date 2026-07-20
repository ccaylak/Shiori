import Foundation

struct JikanFavorites: Decodable {
    
    private(set) var data: FavoriteData
}

struct FavoriteData: Decodable {
    
    private(set) var anime: [FavoriteEntry]
    private(set) var manga: [FavoriteEntry]
    private(set) var characters: [FavoriteEntry]
}

struct FavoriteEntry: Decodable {
    
    private(set) var malId: Int
    private(set) var title: String?
    private(set) var name: String?
    private(set) var type: String?
    private(set) var images: JikanImages
}

extension FavoriteEntry {
    var displayName: String {
        name ?? "?"
    }

    func preferredName(format: NameFormat) -> String {
        format.format(displayName)
    }
}
