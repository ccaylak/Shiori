import SwiftUI

@MainActor final class SeasonManager: ObservableObject {
    static let shared = SeasonManager()
    
    @AppStorage("season.year") var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @AppStorage("season.season") var selectedSeason: Season = Season.current
    
    private init() {}
}
