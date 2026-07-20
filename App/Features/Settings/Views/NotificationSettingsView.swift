import SwiftUI
import SwiftData

struct NotificationSettingsView: View {
    @Environment(AppSettings.self)
    private var settings
    
    @Environment(\.modelContext)
    private var modelContext
    
    var body: some View {
        @Bindable
        var settings = settings
        
        Form {
            Section {
                Toggle(isOn: $settings.airingNotificationsEnabled) {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Episode Notifications")
                                .fontWeight(.medium)

                            Text("Get notified about upcoming episodes of anime you're currently watching.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "bell")
                    }
                }
                .onChange(of: settings.airingNotificationsEnabled) { _, enabled in
                    Task {
                        if enabled {
                            do {
                                let granted = try await AnimeNotificationManager
                                    .requestPermission()

                                guard granted else {
                                    settings.airingNotificationsEnabled = false
                                    return
                                }

                                let schedules = try modelContext.fetch(
                                    FetchDescriptor<AnimeSchedule>()
                                )

                                try await AnimeNotificationManager.scheduleNotifications(
                                    for: schedules,
                                    notificationTime: settings.airingNotificationTiming,
                                    timeFormat: settings.airingNotificationTimeFormat
                                )
                                settings.airingNotificationsEnabled = true
                            } catch {
                                settings.airingNotificationsEnabled = false
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
                    NotificationTimeView(notificationTime: $settings.airingNotificationTiming)
                } label: {
                    Label("Notification Timing", systemImage: "timer")
                }
            } footer: {
                Text("Choose when you want to be notified about a new episode.")
            }
            
            Section {
                Picker("Time Format", systemImage: "clock", selection: $settings.airingNotificationTimeFormat) {
                    ForEach(AiringTimeFormat.allCases, id: \.self) { timeFormat in
                        Text(timeFormat.displayName)
                            .tag(timeFormat)
                    }
                }
                .pickerStyle(.automatic)
            }
        }
        .onChange(of: settings.airingNotificationTiming) {
            rescheduleAiringNotifications()
        }

        .onChange(of: settings.airingNotificationTimeFormat) {
            rescheduleAiringNotifications()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Episode Notifications")
    }
    
    private func rescheduleAiringNotifications() {
        guard settings.airingNotificationsEnabled else {
            return
        }

        Task {
            do {
                let schedules = try modelContext.fetch(
                    FetchDescriptor<AnimeSchedule>()
                )

                try await AnimeNotificationManager.scheduleNotifications(
                    for: schedules,
                    notificationTime: settings.airingNotificationTiming,
                    timeFormat: settings.airingNotificationTimeFormat
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
