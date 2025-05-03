import Foundation

struct OtherTitles: Decodable, Hashable {
    enum CodingKeys: String, CodingKey {
        case en
        case ja
    }
    
    let en: String?
    let ja: String?
    
    init(en: String? = nil, ja: String? = nil) {
        self.en = en
        self.ja = ja
    }
}
