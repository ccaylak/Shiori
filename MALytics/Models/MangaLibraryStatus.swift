import Foundation

struct MangaLibraryStatus: Decodable {
    
    var data: [MediaNode]
    
    init(data: [MediaNode]) {
        self.data = data
    }
}
