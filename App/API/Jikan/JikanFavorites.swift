import Foundation

struct JikanFavorites: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: FavoriteData
}

struct FavoriteData: Decodable {
    enum CodingKeys: String, CodingKey {
        case animes = "anime"
        case mangas = "manga"
        case characters
    }
    
    let animes: [FavoriteEntries]
    let mangas: [FavoriteEntries]
    let characters: [FavoriteEntries]
}

struct FavoriteEntries: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case title, images, name
    }
    
    let title: String?
    let name: String?
    let images: FavoriteImage
}

struct FavoriteImage: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case jpg
    }
    let jpg: FavoriteJPG
}

struct FavoriteJPG: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
    
    let imageUrl: String
    let smallImageUrl: String?
    let largeImageUrl: String?
}

@MainActor
extension FavoriteEntries {
    var getName: String {
        name ?? "?"
    }
    
    var formattedName: String {
        let nameFormat = SettingsManager.shared.namePresentation
        
        switch nameFormat {
        case "Last Name, First Name":
            return getName
            
        default:
            
            let parts = getName.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else {
                return getName
            }
            return "\(parts[1]) \(parts[0])"
        }
    }
}
