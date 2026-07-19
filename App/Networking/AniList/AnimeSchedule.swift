import Foundation
import SwiftData

@Model
final class AnimeSchedule {
    @Attribute(.unique)
    var malId: Int

    var englishTitle: String?
    var romajiTitle: String?
    var nativeTitle: String?

    var episodeNumber: Int
    var airingAt: Date

    init(
        malId: Int,
        englishTitle: String?,
        romajiTitle: String?,
        nativeTitle: String?,
        episodeNumber: Int,
        airingAt: Date
    ) {
        self.malId = malId
        self.englishTitle = englishTitle
        self.romajiTitle = romajiTitle
        self.nativeTitle = nativeTitle
        self.episodeNumber = episodeNumber
        self.airingAt = airingAt
    }
}
