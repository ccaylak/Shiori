import Foundation

struct AnimeNode: Decodable, Hashable {
    let node: Anime
    
    init(node: Anime) {
        self.node = node
    }
}
