import Foundation

struct MangaNode: Decodable {
    let node: Manga
    
    init(node: Manga) {
        self.node = node
    }
}
