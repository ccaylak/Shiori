import Foundation

struct StartSeason: Decodable, Hashable {
    private(set) var year: Int?
    private(set) var season: Season?
    
    init() { }
}

extension StartSeason {
    
    var seasonLabel: String {
        if let season, let year {
            return "\(season.displayName) \(year)"
        } else if let season {
            return season.displayName
        } else if let year {
            return "\(year)"
        } else {
            return "Unknown release year"
        }
    }
}
