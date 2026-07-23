import Foundation

@MainActor
final class SettingsCloudSync: NSObject {
    private let cloudStore: NSUbiquitousKeyValueStore
    private var isObserving = false

    var onChangedKeys: (([SettingsKey]) -> Void)?

    init(
        cloudStore: NSUbiquitousKeyValueStore = .default
    ) {
        self.cloudStore = cloudStore

        super.init()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle

    func start() {
        guard !isObserving else {
            return
        }

        isObserving = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cloudStoreDidChange(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: cloudStore
        )

        cloudStore.synchronize()
    }

    func stop() {
        guard isObserving else {
            return
        }

        NotificationCenter.default.removeObserver(
            self,
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: cloudStore
        )

        isObserving = false
    }

    // MARK: - Writing

    func set<Value>(
        _ value: Value,
        for key: SettingsKey
    ) {
        cloudStore.set(
            value,
            forKey: key.rawValue
        )
    }

    // MARK: - Reading

    func object(
        for key: SettingsKey
    ) -> Any? {
        cloudStore.object(
            forKey: key.rawValue
        )
    }

    func contains(
        _ key: SettingsKey
    ) -> Bool {
        object(for: key) != nil
    }

    func bool(
        for key: SettingsKey
    ) -> Bool? {
        guard contains(key) else {
            return nil
        }

        return cloudStore.bool(
            forKey: key.rawValue
        )
    }

    // MARK: - Notifications

    @objc
    private nonisolated func cloudStoreDidChange(
        _ notification: Notification
    ) {
        let changedRawKeys = notification.userInfo?[
            NSUbiquitousKeyValueStoreChangedKeysKey
        ] as? [String]

        let changedKeys: [SettingsKey]

        if let changedRawKeys {
            changedKeys = changedRawKeys.compactMap(
                SettingsKey.init(rawValue:)
            )
        } else {
            changedKeys = SettingsKey.allCases
        }

        Task { @MainActor [weak self, changedKeys] in
            self?.onChangedKeys?(changedKeys)
        }
    }
}
