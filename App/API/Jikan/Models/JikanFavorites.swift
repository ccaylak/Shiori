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

@MainActor
extension FavoriteEntry {
    var getName: String {
        name ?? "?"
    }
    
    var formattedName: String {
        let nameFormat = SettingsManager.shared.namePresentation
        
        switch nameFormat {
        case .lastFirst:
            return getName
            
        case .firstLast:
            
            let parts = getName.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else {
                return getName
            }
            return "\(parts[1]) \(parts[0])"
        }
    }
}
