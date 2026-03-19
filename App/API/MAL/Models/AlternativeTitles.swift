import Foundation

struct AlternativeTitles: Decodable, Hashable {
    private(set) var synonyms: [String]
    private(set) var en: String?
    private(set) var ja: String?
}
