import Foundation
import UserNotifications

enum AnimeNotificationManager {
    
    private static let identifierPrefix = "anime-airing-"
    
    static func requestPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound])
    }
    
    static func scheduleNotifications(
        for schedules: [AnimeSchedule],
        notificationTime: AiringNotificationTiming,
        timeFormat: AiringTimeFormat
    ) async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .authorized ||
                settings.authorizationStatus == .provisional else {
            return
        }

        let pendingRequests = await center.pendingNotificationRequests()

        let existingIdentifiers = pendingRequests
            .map(\.identifier)
            .filter {
                $0.hasPrefix(identifierPrefix)
            }

        center.removePendingNotificationRequests(
            withIdentifiers: existingIdentifiers
        )

        let calendar = Calendar.current

        for schedule in schedules {
            let notificationDate: Date

            switch notificationTime {
            case .sameDay:
                guard let sameDayNotificationDate = calendar.date(
                    bySettingHour: 12,
                    minute: 0,
                    second: 0,
                    of: schedule.airingAt
                ) else {
                    continue
                }

                notificationDate = sameDayNotificationDate

            case .airing, .fifteenMinutes, .oneHour:
                guard let calculatedNotificationDate = calendar.date(
                    byAdding: .minute,
                    value: -notificationTime.value,
                    to: schedule.airingAt
                ) else {
                    continue
                }

                notificationDate = calculatedNotificationDate
            }

            guard notificationDate > .now else {
                continue
            }

            let title =
                schedule.englishTitle ??
                schedule.romajiTitle ??
                schedule.nativeTitle ??
                "Upcoming Anime"

            let content = UNMutableNotificationContent()
            content.title = title

            switch notificationTime {
            case .airing:
                content.body = String(localized: "Episode \(schedule.episodeNumber) is now available.")

            case .fifteenMinutes:
                content.body = String(localized: "Episode \(schedule.episodeNumber) airs in 15 minutes.")

            case .oneHour:
                content.body = String(localized: "Episode \(schedule.episodeNumber) airs in 1 hour.")

            case .sameDay:
                let airingTime = formattedAiringTime(
                    for: schedule.airingAt,
                    format: timeFormat
                )

                content.body = String(localized: "Episode \(schedule.episodeNumber) airs today at \(airingTime).")
            }

            content.sound = .default
            content.threadIdentifier = "anime-airing"
            content.userInfo = [
                "malId": schedule.malId
            ]

            var dateComponents = calendar.dateComponents(
                [
                    .year,
                    .month,
                    .day,
                    .hour,
                    .minute,
                    .second
                ],
                from: notificationDate
            )

            dateComponents.timeZone = .current

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: "\(identifierPrefix)\(schedule.malId)",
                content: content,
                trigger: trigger
            )

            try await center.add(request)
        }
    }
    
    static func cancelNotifications() async {
        let center = UNUserNotificationCenter.current()
        let pendingRequests = await center.pendingNotificationRequests()
        
        let identifiers = pendingRequests
            .map(\.identifier)
            .filter {
                $0.hasPrefix(identifierPrefix)
            }
        
        center.removePendingNotificationRequests(
            withIdentifiers: identifiers
        )
    }
    
    static func scheduleTestNotification(
        notificationTime: AiringNotificationTiming,
        timeFormat: AiringTimeFormat,
        episodeNumber: Int
    ) async throws {
        let granted = try await requestPermission()
        guard granted else { return }

        let content = UNMutableNotificationContent()
        content.title = "Uma Musume: Cinderella Gray"
        content.sound = .default

        switch notificationTime {
        case .airing:
            content.body = String(localized: "Episode \(episodeNumber) is now available.")
            
        case .fifteenMinutes:
            content.body = String(localized: "Episode \(episodeNumber) airs in 15 minutes.")
            
        case .oneHour:
            content.body = String(localized: "Episode \(episodeNumber) airs in 1 hour.")
            
        case .sameDay:
            switch timeFormat {
            case .twentyFourHour:
                content.body = String(localized: "Episode \(episodeNumber) airs today at 20:00.")
                
            case .twelveHour:
                content.body = String(localized: "Episode \(episodeNumber) airs today at 8:00 PM.")
            }
        }

        let identifier = "test-episode-notification"

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [identifier]
            )

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 0.01,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        try await UNUserNotificationCenter.current().add(request)
    }
    
    private static func formattedAiringTime(
        for date: Date,
        format: AiringTimeFormat
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current

        switch format {
        case .twentyFourHour:
            formatter.dateFormat = "HH:mm"

        case .twelveHour:
            formatter.dateFormat = "h:mm a"
        }

        return formatter.string(from: date)
    }
}
