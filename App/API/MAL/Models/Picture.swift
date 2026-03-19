import Foundation

struct Picture: Decodable, Hashable {
    private(set) var large: String? = nil
    private(set) var medium: String = ""
    
    init() {}
}

extension Picture {
    var largeUrl: String {
        large ?? medium
    }
}
