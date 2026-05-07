import WidgetKit

enum ControlCenterReloader {
    static func reloadBrightnessControls() {
        ControlCenter.shared.reloadControls(ofKind: AppConstants.controlKindSetFullBrightness)
        ControlCenter.shared.reloadControls(ofKind: AppConstants.controlKindAutoFullMode)
    }
}
