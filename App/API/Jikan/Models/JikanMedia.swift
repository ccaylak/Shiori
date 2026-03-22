import Foundation

struct JikanMedia: Decodable {
    
    private(set) var data: [JikanMediaData]
    private(set) var pagination: JikanPagination?
    
    mutating func append(_ newData: [JikanMediaData]) {
        data.append(contentsOf: newData)
    }
}

struct JikanMediaData: Decodable, Identifiable {
    
    private(set) var malId: Int
    private(set) var titles: [JikanTitle]
    private(set) var images: JikanImages
    private(set) var type: String?
    private(set) var status: String?
    private(set) var score: Double?
    
    var id: Int {malId}
}

extension JikanMediaData {
    var preferredTitle: String {
        let value = UserDefaults.standard.string(forKey: "titleLanguage") ?? TitleLanguage.romanji.rawValue

        switch value {
        case "romanji":
            return titles.first { $0.type == "Default" }?.title
                ?? titles.first?.title
                ?? ""

        case "english":
            return titles.first { $0.type == "English" }?.title
                ?? titles.first?.title
                ?? ""

        case "japanese":
            return titles.first { $0.type == "Japanese" }?.title
                ?? titles.first?.title
                ?? ""

        default:
            return titles.first?.title ?? ""
        }
    }
}
