import Foundation

struct Images: Decodable, Hashable {
    let medium: String
    let large: String
    
    init(large: String, medium: String = "") {
        self.medium = medium
        self.large = large
    }
}
