import Foundation

struct Picture: Decodable, Hashable {
    private(set) var large: String? = nil
    private(set) var medium: String = ""
    
    init(large: String? = nil, medium: String) {
        self.large = large
        self.medium = medium
    }
}

extension Picture {
    var largeUrl: String {
        large ?? medium
    }
}
