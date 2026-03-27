import Foundation

struct StartSeason: Decodable, Hashable {
    private(set) var year: Int?
    private(set) var season: String?
    
    init() { }
}

extension StartSeason {
    
    var seasonLabel: String {
        if let season, let year {
            return "\(season.capitalized) \(year)"
        } else if let season {
            return season.capitalized
        } else if let year {
            return "\(year)"
        } else {
            return "Unknown release year"
        }
    }
}
