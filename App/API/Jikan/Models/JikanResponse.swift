import Foundation

struct JikanResponse: Decodable {
    
    private(set) var data: AnimeManga
    
    struct AnimeManga: Decodable {
        
        private(set) var anime: AnimeStatistics
        private(set) var manga: MangaStatistics
        
        struct AnimeStatistics: Decodable {
            
            private(set) var watching: Int
            private(set) var completed: Int
            private(set) var dropped: Int
            private(set) var onHold: Int
            private(set) var planToWatch: Int
        }
        
        struct MangaStatistics: Decodable {
            
            private(set) var reading: Int
            private(set) var completed: Int
            private(set) var dropped: Int
            private(set) var onHold: Int
            private(set) var planToRead: Int
        }
    }
}
