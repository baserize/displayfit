actor DisplayBrightnessClient {
    static let shared = DisplayBrightnessClient()

    private let controller = DisplayBrightnessController()

    func displays() -> [DisplayDevice] {
        controller.displays()
    }

    func setAllDisplays(to targetBrightness: Float) -> BrightnessRunResult {
        controller.setAllDisplays(to: targetBrightness)
    }
}
