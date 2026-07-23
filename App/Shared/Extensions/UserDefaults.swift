import Foundation

extension UserDefaults {
    func boolValue(
        forKey key: String,
        default defaultValue: Bool
    ) -> Bool {
        guard object(forKey: key) != nil else {
            return defaultValue
        }

        return bool(forKey: key)
    }

    func enumValue<Value: RawRepresentable>(
        forKey key: String,
        default defaultValue: Value
    ) -> Value {
        guard
            let rawValue = object(forKey: key) as? Value.RawValue,
            let value = Value(rawValue: rawValue)
        else {
            return defaultValue
        }

        return value
    }

    func intValue(
        forKey key: String,
        default defaultValue: Int
    ) -> Int {
        guard object(forKey: key) != nil else {
            return defaultValue
        }

        return integer(forKey: key)
    }
}
