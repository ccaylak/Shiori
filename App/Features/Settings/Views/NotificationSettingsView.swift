import SwiftUI
import SwiftData

struct NotificationSettingsView: View {
    @ObservedObject
    private var settingsManager: SettingsManager = .shared
    
    @Environment(\.modelContext)
    private var modelContext
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $settingsManager.airingNotificationsEnabled) {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Episode Notifications")
                                .fontWeight(.medium)

                            Text("Get notified about upcoming episodes of anime you're watching.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "bell.badge")
                    }
                }
                .onChange(of: settingsManager.airingNotificationsEnabled) { _, enabled in
                    Task {
                        if enabled {
                            do {
                                let granted = try await AnimeNotificationManager
                                    .requestPermission()

                                guard granted else {
                                    settingsManager.airingNotificationsEnabled = false
                                    return
                                }

                                let schedules = try modelContext.fetch(
                                    FetchDescriptor<AnimeSchedule>()
                                )

                                try await AnimeNotificationManager.scheduleNotifications(
                                    for: schedules,
                                    notificationTime: settingsManager.airingNotificationTiming,
                                    timeFormat: settingsManager.airingNotificationTimeFormat
                                )
                            } catch {
                                settingsManager.airingNotificationsEnabled = false
                                print("Notification setup failed:", error)
                            }
                        } else {
                            await AnimeNotificationManager.cancelNotifications()
                        }
                    }
                }
            }
            
            Section {
                NavigationLink {
                    NotificationTimeView(notificationTime: $settingsManager.airingNotificationTiming)
                } label: {
                    Label("Notify Me", systemImage: "timer")
                }
            } footer: {
                Text("Choose when you want to be notified relative to the episode airing time.")
            }
            
            Section {
                Picker("Time Format", systemImage: "clock", selection: $settingsManager.airingNotificationTimeFormat) {
                    ForEach(AiringTimeFormat.allCases, id: \.self) { timeFormat in
                        Text(timeFormat.displayName)
                            .tag(timeFormat)
                    }
                }
                .pickerStyle(.automatic)
            }
        }
        .onChange(of: settingsManager.airingNotificationTiming) {
            rescheduleAiringNotifications()
        }

        .onChange(of: settingsManager.airingNotificationTimeFormat) {
            rescheduleAiringNotifications()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Anime Notifications")
    }
    
    private func rescheduleAiringNotifications() {
        guard settingsManager.airingNotificationsEnabled else {
            return
        }

        Task {
            do {
                let schedules = try modelContext.fetch(
                    FetchDescriptor<AnimeSchedule>()
                )

                try await AnimeNotificationManager.scheduleNotifications(
                    for: schedules,
                    notificationTime: settingsManager.airingNotificationTiming,
                    timeFormat: settingsManager.airingNotificationTimeFormat
                )
            } catch {
                print("Failed to reschedule notifications:", error)
            }
        }
    }
}

struct NotificationTimeView: View {
    @Binding var notificationTime: AiringNotificationTiming

    var body: some View {
        Form {
            Section {
                Picker("Notify Me", selection: $notificationTime) {
                    ForEach(AiringNotificationTiming.allCases, id: \.self) { timing in
                        Text(timing.displayName)
                            .tag(timing)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            } footer: {
                Text("Choose when you want to be notified relative to the episode airing time.")
            }
            
            Button {
                Task {
                    do {
                        try await AnimeNotificationManager
                            .scheduleTestNotification(notificationTime: notificationTime, timeFormat: .twentyFourHour, episodeNumber: 1)
                    } catch {
                        print("Test notification failed:", error)
                    }
                }
            } label: {
                Label(
                    "Preview Notification",
                    systemImage: "bell.badge"
                )
            }
        }
        .navigationTitle("Notify Me")
        .navigationBarTitleDisplayMode(.inline)
    }
}
