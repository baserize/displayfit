import Foundation

struct KeyboardShortcutPreferences {
    func shortcut(for action: ShortcutAction) -> AppKeyboardShortcut {
        guard let value = CFPreferencesCopyAppValue(key(for: action) as CFString, AppConstants.appBundleIdentifier as CFString) as? String,
              let shortcut = AppKeyboardShortcut(serializedValue: value) else {
            return action.defaultShortcut
        }

        return shortcut
    }

    func setShortcut(_ shortcut: AppKeyboardShortcut, for action: ShortcutAction) {
        CFPreferencesSetAppValue(
            key(for: action) as CFString,
            shortcut.serializedValue as CFString,
            AppConstants.appBundleIdentifier as CFString
        )
        CFPreferencesAppSynchronize(AppConstants.appBundleIdentifier as CFString)
    }

    func resetShortcut(for action: ShortcutAction) {
        CFPreferencesSetAppValue(
            key(for: action) as CFString,
            nil,
            AppConstants.appBundleIdentifier as CFString
        )
        CFPreferencesAppSynchronize(AppConstants.appBundleIdentifier as CFString)
    }

    private func key(for action: ShortcutAction) -> String {
        "keyboardShortcut.\(action.rawValue)"
    }
}
