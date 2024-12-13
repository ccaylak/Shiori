import Foundation

struct LibraryResponse: Decodable {
    
    var data: [MediaNode]
    
    init(data: [MediaNode]) {
        self.data = data
    }
}
