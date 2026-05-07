import Foundation

struct BrightnessPreferences: Sendable {
    static let defaultTargetBrightnessPercent = 100
    static let targetBrightnessPercentRange = 1...100

    private enum Key {
        static let autoFullEnabled = "autoMaxEnabled"
        static let targetBrightnessPercent = "targetBrightnessPercent"
    }

    var autoFullEnabled: Bool {
        get {
            let value = CFPreferencesCopyAppValue(Key.autoFullEnabled as CFString, AppConstants.appBundleIdentifier as CFString)
            return (value as? Bool) ?? false
        }
        nonmutating set {
            CFPreferencesSetAppValue(Key.autoFullEnabled as CFString, newValue as CFBoolean, AppConstants.appBundleIdentifier as CFString)
            CFPreferencesAppSynchronize(AppConstants.appBundleIdentifier as CFString)
        }
    }

    var targetBrightnessPercent: Int {
        get {
            let value = CFPreferencesCopyAppValue(Key.targetBrightnessPercent as CFString, AppConstants.appBundleIdentifier as CFString)
            let percent = (value as? NSNumber)?.intValue ?? Self.defaultTargetBrightnessPercent
            return Self.clampedTargetBrightnessPercent(percent)
        }
        nonmutating set {
            let percent = Self.clampedTargetBrightnessPercent(newValue)
            CFPreferencesSetAppValue(
                Key.targetBrightnessPercent as CFString,
                NSNumber(value: percent),
                AppConstants.appBundleIdentifier as CFString
            )
            CFPreferencesAppSynchronize(AppConstants.appBundleIdentifier as CFString)
        }
    }

    var targetBrightnessValue: Float {
        Float(targetBrightnessPercent) / 100
    }

    static func clampedTargetBrightnessPercent(_ percent: Int) -> Int {
        min(max(percent, targetBrightnessPercentRange.lowerBound), targetBrightnessPercentRange.upperBound)
    }
}
