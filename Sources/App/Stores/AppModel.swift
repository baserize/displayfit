import AppKit
import CoreGraphics
import Foundation
import Observation

@MainActor
@Observable
final class AppModel {
    private let brightnessClient = DisplayBrightnessClient.shared
    private var preferences = BrightnessPreferences()
    private var monitor: DisplayConnectionMonitor?
    private var screenParametersObserver: NSObjectProtocol?
    private var autoBrightnessTask: Task<Void, Never>?
    private var displayRefreshTask: Task<Void, Never>?

    var displays: [DisplayDevice] = []
    var lastRunResult: BrightnessRunResult?

    var autoFullEnabled: Bool {
        get { preferences.autoFullEnabled }
        set {
            guard preferences.autoFullEnabled != newValue else { return }
            preferences.autoFullEnabled = newValue
            ControlCenterReloader.reloadBrightnessControls()

            if newValue {
                setAllDisplaysToFullBrightness()
            } else {
                autoBrightnessTask?.cancel()
                autoBrightnessTask = nil
            }
        }
    }

    var targetBrightnessPercent: Int {
        get { preferences.targetBrightnessPercent }
        set {
            let clampedValue = BrightnessPreferences.clampedTargetBrightnessPercent(newValue)
            guard preferences.targetBrightnessPercent != clampedValue else { return }

            preferences.targetBrightnessPercent = clampedValue
            lastRunResult = nil
            ControlCenterReloader.reloadBrightnessControls()
        }
    }

    init() {
        refreshDisplays()
        monitor = DisplayConnectionMonitor { [weak self] _, flags in
            self?.handleDisplayChange(flags: flags)
        }
        observeScreenParameterChanges()
        startDisplayRefreshPolling()

        if autoFullEnabled {
            scheduleAutoBrightnessPass()
        }
    }

    func refreshDisplays() {
        let brightnessClient = brightnessClient

        Task { [weak self] in
            let latestDisplays = await brightnessClient.displays()
            self?.applyDisplays(latestDisplays, clearsLastRunResult: false)
        }
    }

    func setAllDisplaysToFullBrightness() {
        let brightnessClient = brightnessClient
        let targetBrightness = preferences.targetBrightnessValue

        Task { [weak self] in
            let result = await brightnessClient.setAllDisplays(to: targetBrightness)
            let latestDisplays = await brightnessClient.displays()
            self?.applyBrightnessRunResult(result, displays: latestDisplays)
        }
    }

    private func handleDisplayChange(flags: CGDisplayChangeSummaryFlags) {
        refreshDisplays()

        guard autoFullEnabled, flags.shouldTriggerAutoBrightness else { return }
        scheduleAutoBrightnessPass()
    }

    private func observeScreenParameterChanges() {
        screenParametersObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleScreenParametersChange()
            }
        }
    }

    private func handleScreenParametersChange() {
        refreshDisplays()

        if autoFullEnabled {
            scheduleAutoBrightnessPass()
        }
    }

    private func startDisplayRefreshPolling() {
        displayRefreshTask?.cancel()
        let brightnessClient = brightnessClient

        displayRefreshTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: RefreshCadence.displayPolling)
                guard !Task.isCancelled else { return }

                let latestDisplays = await brightnessClient.displays()
                self?.applyDisplays(latestDisplays, clearsLastRunResult: true)
            }
        }
    }

    private func applyDisplays(_ latestDisplays: [DisplayDevice], clearsLastRunResult: Bool) {
        guard latestDisplays != displays else { return }

        displays = latestDisplays
        if clearsLastRunResult {
            lastRunResult = nil
        }
    }

    private func applyBrightnessRunResult(_ result: BrightnessRunResult, displays latestDisplays: [DisplayDevice]) {
        lastRunResult = result
        applyDisplays(latestDisplays, clearsLastRunResult: false)
        ControlCenterReloader.reloadBrightnessControls()
    }

    private func scheduleAutoBrightnessPass() {
        autoBrightnessTask?.cancel()

        autoBrightnessTask = Task { [weak self] in
            for delay in RefreshCadence.autoBrightnessDelays {
                try? await Task.sleep(for: delay)
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    guard self?.autoFullEnabled == true else { return }
                    self?.setAllDisplaysToFullBrightness()
                }
            }
        }
    }
}

private enum RefreshCadence {
    static let displayPolling: Duration = .milliseconds(500)
    static let autoBrightnessDelays: [Duration] = [.milliseconds(600), .seconds(2), .seconds(5)]
}

private extension CGDisplayChangeSummaryFlags {
    var shouldTriggerAutoBrightness: Bool {
        contains(.addFlag) || contains(.enabledFlag) || contains(.setModeFlag)
    }
}
