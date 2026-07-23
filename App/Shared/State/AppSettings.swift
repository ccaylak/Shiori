import Foundation
import Observation

@MainActor
@Observable
final class AppSettings {

    @ObservationIgnored
    private let defaults: UserDefaults

    @ObservationIgnored
    private let cloudSync: SettingsCloudSync

    @ObservationIgnored
    private var isApplyingCloudValue = false
    
    private enum DefaultValue {
            static let appearance: Appearance = .system
            static let accentColor: AccentColor = .red
            static let showNsfwContent = true

            static let titleLanguage: TitleLanguage = .english
            static let mangaFormat: MangaFormat = .chapter
            static let animeFormat: AnimeFormat = .episode
            static let nameFormat: NameFormat = .firstLast

            static let includeFirstEpisodeInDuration = true
            static let advancedMode = false

            static let isExtendedDataEnabled = true
            static let extendedDataSource: APIService = .tenrai

            static let airingNotificationsEnabled = false
            static let airingNotificationTiming: AiringNotificationTiming = .airing
            static let airingNotificationTimeFormat: AiringTimeFormat = .twentyFourHour
        }

    var appearance: Appearance {
        didSet {
            save(
                appearance.rawValue,
                for: .appearance
            )
        }
    }

    var accentColor: AccentColor {
        didSet {
            save(
                accentColor.rawValue,
                for: .accentColor
            )
        }
    }

    var showNsfwContent: Bool {
        didSet {
            save(
                showNsfwContent,
                for: .nsfw
            )
        }
    }

    var titleLanguage: TitleLanguage {
        didSet {
            save(
                titleLanguage.rawValue,
                for: .titleLanguage
            )
        }
    }

    var mangaFormat: MangaFormat {
        didSet {
            save(
                mangaFormat.rawValue,
                for: .mangaFormat
            )
        }
    }

    var animeFormat: AnimeFormat {
        didSet {
            save(
                animeFormat.rawValue,
                for: .animeFormat
            )
        }
    }

    var nameFormat: NameFormat {
        didSet {
            save(
                nameFormat.rawValue,
                for: .nameFormat
            )
        }
    }

    var includeFirstEpisodeInDuration: Bool {
        didSet {
            save(
                includeFirstEpisodeInDuration,
                for: .includeFirstEpisodeInDuration
            )
        }
    }

    var advancedMode: Bool {
        didSet {
            save(
                advancedMode,
                for: .advancedMode
            )
        }
    }

    var isExtendedDataEnabled: Bool {
        didSet {
            save(
                isExtendedDataEnabled,
                for: .isExtendedDataEnabled
            )
        }
    }

    var extendedDataSource: APIService {
        didSet {
            save(
                extendedDataSource.rawValue,
                for: .extendedDataSource
            )
        }
    }

    var airingNotificationsEnabled: Bool {
        didSet {
            save(
                airingNotificationsEnabled,
                for: .airingNotificationsEnabled
            )
        }
    }

    var airingNotificationTiming: AiringNotificationTiming {
        didSet {
            save(
                airingNotificationTiming.rawValue,
                for: .airingNotificationTiming
            )
        }
    }

    var airingNotificationTimeFormat: AiringTimeFormat {
        didSet {
            save(
                airingNotificationTimeFormat.rawValue,
                for: .airingNotificationTimeFormat
            )
        }
    }

    init(
        defaults: UserDefaults = .standard,
        cloudSync: SettingsCloudSync? = nil
    ) {
        self.defaults = defaults
        self.cloudSync = cloudSync ?? SettingsCloudSync()

        appearance = defaults.enumValue(
            forKey: SettingsKey.appearance.rawValue,
            default: DefaultValue.appearance
        )

        accentColor = defaults.enumValue(
            forKey: SettingsKey.accentColor.rawValue,
            default: DefaultValue.accentColor
        )

        showNsfwContent = defaults.boolValue(
            forKey: SettingsKey.nsfw.rawValue,
            default: DefaultValue.showNsfwContent
        )

        titleLanguage = defaults.enumValue(
            forKey: SettingsKey.titleLanguage.rawValue,
            default: DefaultValue.titleLanguage
        )

        mangaFormat = defaults.enumValue(
            forKey: SettingsKey.mangaFormat.rawValue,
            default: DefaultValue.mangaFormat
        )

        animeFormat = defaults.enumValue(
            forKey: SettingsKey.animeFormat.rawValue,
            default: DefaultValue.animeFormat
        )

        nameFormat = defaults.enumValue(
            forKey: SettingsKey.nameFormat.rawValue,
            default: DefaultValue.nameFormat
        )

        includeFirstEpisodeInDuration = defaults.boolValue(
            forKey: SettingsKey.includeFirstEpisodeInDuration.rawValue,
            default: DefaultValue.includeFirstEpisodeInDuration
        )

        advancedMode = defaults.boolValue(
            forKey: SettingsKey.advancedMode.rawValue,
            default: DefaultValue.advancedMode
        )

        isExtendedDataEnabled = defaults.boolValue(
            forKey: SettingsKey.isExtendedDataEnabled.rawValue,
            default: DefaultValue.isExtendedDataEnabled
        )

        extendedDataSource = defaults.enumValue(
            forKey: SettingsKey.extendedDataSource.rawValue,
            default: DefaultValue.extendedDataSource
        )

        airingNotificationsEnabled = defaults.boolValue(
            forKey: SettingsKey.airingNotificationsEnabled.rawValue,
            default: DefaultValue.airingNotificationsEnabled
        )

        airingNotificationTiming = defaults.enumValue(
            forKey: SettingsKey.airingNotificationTiming.rawValue,
            default: DefaultValue.airingNotificationTiming
        )

        airingNotificationTimeFormat = defaults.enumValue(
            forKey: SettingsKey.airingNotificationTimeFormat.rawValue,
            default: DefaultValue.airingNotificationTimeFormat
        )

        self.cloudSync.onChangedKeys = { [weak self] keys in
            self?.applyCloudValues(for: keys)
        }

        self.cloudSync.start()
        mergeCloudSettings()
    }

    func resetToDefaults() {
        appearance = DefaultValue.appearance
        accentColor = DefaultValue.accentColor
        showNsfwContent = DefaultValue.showNsfwContent

        titleLanguage = DefaultValue.titleLanguage
        mangaFormat = DefaultValue.mangaFormat
        animeFormat = DefaultValue.animeFormat
        nameFormat = DefaultValue.nameFormat

        includeFirstEpisodeInDuration =
            DefaultValue.includeFirstEpisodeInDuration

        advancedMode = DefaultValue.advancedMode

        isExtendedDataEnabled =
            DefaultValue.isExtendedDataEnabled

        extendedDataSource =
            DefaultValue.extendedDataSource

        airingNotificationsEnabled =
            DefaultValue.airingNotificationsEnabled

        airingNotificationTiming =
            DefaultValue.airingNotificationTiming

        airingNotificationTimeFormat =
            DefaultValue.airingNotificationTimeFormat
    }
    
    private func save<Value>(
        _ value: Value,
        for key: SettingsKey
    ) {
        defaults.set(
            value,
            forKey: key.rawValue
        )

        guard !isApplyingCloudValue else {
            return
        }

        cloudSync.set(
            value,
            for: key
        )
    }
    
    private func mergeCloudSettings() {
        isApplyingCloudValue = true

        defer {
            isApplyingCloudValue = false
        }

        for key in SettingsKey.allCases {
            if cloudSync.contains(key) {
                applyCloudValue(for: key)
            } else {
                uploadLocalValue(for: key)
            }
        }
    }

    private func applyCloudValues(
        for keys: [SettingsKey]
    ) {
        isApplyingCloudValue = true

        defer {
            isApplyingCloudValue = false
        }

        for key in keys {
            guard cloudSync.contains(key) else {
                continue
            }

            applyCloudValue(for: key)
        }
    }

    private func applyCloudValue(
        for key: SettingsKey
    ) {
        switch key {
        case .appearance:
            guard let value: Appearance = cloudEnumValue(
                for: key
            ) else {
                return
            }

            appearance = value

        case .accentColor:
            guard let value: AccentColor = cloudEnumValue(
                for: key
            ) else {
                return
            }

            accentColor = value

        case .nsfw:
            guard let value = cloudSync.bool(
                for: key
            ) else {
                return
            }

            showNsfwContent = value

        case .titleLanguage:
            guard let value: TitleLanguage = cloudEnumValue(
                for: key
            ) else {
                return
            }

            titleLanguage = value

        case .mangaFormat:
            guard let value: MangaFormat = cloudEnumValue(
                for: key
            ) else {
                return
            }

            mangaFormat = value

        case .animeFormat:
            guard let value: AnimeFormat = cloudEnumValue(
                for: key
            ) else {
                return
            }

            animeFormat = value

        case .nameFormat:
            guard let value: NameFormat = cloudEnumValue(
                for: key
            ) else {
                return
            }

            nameFormat = value

        case .includeFirstEpisodeInDuration:
            guard let value = cloudSync.bool(
                for: key
            ) else {
                return
            }

            includeFirstEpisodeInDuration = value

        case .advancedMode:
            guard let value = cloudSync.bool(
                for: key
            ) else {
                return
            }

            advancedMode = value

        case .isExtendedDataEnabled:
            guard let value = cloudSync.bool(
                for: key
            ) else {
                return
            }

            isExtendedDataEnabled = value

        case .extendedDataSource:
            guard let value: APIService = cloudEnumValue(
                for: key
            ) else {
                return
            }

            extendedDataSource = value

        case .airingNotificationsEnabled:
            guard let value = cloudSync.bool(
                for: key
            ) else {
                return
            }

            airingNotificationsEnabled = value

        case .airingNotificationTiming:
            guard let value: AiringNotificationTiming = cloudEnumValue(
                for: key
            ) else {
                return
            }

            airingNotificationTiming = value

        case .airingNotificationTimeFormat:
            guard let value: AiringTimeFormat = cloudEnumValue(
                for: key
            ) else {
                return
            }

            airingNotificationTimeFormat = value
        }
    }

    private func uploadLocalValue(
        for key: SettingsKey
    ) {
        switch key {
        case .appearance:
            cloudSync.set(
                appearance.rawValue,
                for: key
            )

        case .accentColor:
            cloudSync.set(
                accentColor.rawValue,
                for: key
            )

        case .nsfw:
            cloudSync.set(
                showNsfwContent,
                for: key
            )

        case .titleLanguage:
            cloudSync.set(
                titleLanguage.rawValue,
                for: key
            )

        case .mangaFormat:
            cloudSync.set(
                mangaFormat.rawValue,
                for: key
            )

        case .animeFormat:
            cloudSync.set(
                animeFormat.rawValue,
                for: key
            )

        case .nameFormat:
            cloudSync.set(
                nameFormat.rawValue,
                for: key
            )

        case .includeFirstEpisodeInDuration:
            cloudSync.set(
                includeFirstEpisodeInDuration,
                for: key
            )

        case .advancedMode:
            cloudSync.set(
                advancedMode,
                for: key
            )

        case .isExtendedDataEnabled:
            cloudSync.set(
                isExtendedDataEnabled,
                for: key
            )

        case .extendedDataSource:
            cloudSync.set(
                extendedDataSource.rawValue,
                for: key
            )

        case .airingNotificationsEnabled:
            cloudSync.set(
                airingNotificationsEnabled,
                for: key
            )

        case .airingNotificationTiming:
            cloudSync.set(
                airingNotificationTiming.rawValue,
                for: key
            )

        case .airingNotificationTimeFormat:
            cloudSync.set(
                airingNotificationTimeFormat.rawValue,
                for: key
            )
        }
    }

    private func cloudEnumValue<Value>(
        for key: SettingsKey
    ) -> Value? where Value: RawRepresentable {
        guard let object = cloudSync.object(
            for: key
        ) else {
            return nil
        }

        if let rawValue = object as? Value.RawValue {
            return Value(
                rawValue: rawValue
            )
        }
        
        if let number = object as? NSNumber {
            if let rawValue = number.intValue as? Value.RawValue {
                return Value(
                    rawValue: rawValue
                )
            }

            if let rawValue = number.int64Value as? Value.RawValue {
                return Value(
                    rawValue: rawValue
                )
            }

            if let rawValue = number.doubleValue as? Value.RawValue {
                return Value(
                    rawValue: rawValue
                )
            }
        }

        return nil
    }
}
