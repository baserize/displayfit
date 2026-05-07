import SwiftUI

struct SettingsView: View {
    @Bindable var model: AppModel
    @State private var launchAtLoginState = LaunchAtLoginController().state
    @State private var launchAtLoginError: String?

    private let launchAtLoginController = LaunchAtLoginController()

    var body: some View {
        Form {
            Section("settings.section.brightness") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("settings.full_level", systemImage: "sun.max.fill")

                        Spacer()

                        Text(L10n.string("brightness.percent_format", model.targetBrightnessPercent))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }

                    Slider(
                        value: targetBrightnessSliderBinding,
                        in: Double(BrightnessPreferences.targetBrightnessPercentRange.lowerBound)...Double(BrightnessPreferences.targetBrightnessPercentRange.upperBound),
                        step: 1
                    )
                }
            }

            Section("settings.section.general") {
                Toggle(isOn: launchAtLoginBinding) {
                    Label("settings.launch_at_login", systemImage: "power")
                }

                if launchAtLoginState == .requiresApproval {
                    Label("settings.launch_at_login.requires_approval", systemImage: "exclamationmark.circle")
                        .foregroundStyle(.orange)
                }

                if let launchAtLoginError {
                    Label(L10n.string("settings.error_format", launchAtLoginError), systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                }
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 460)
        .onAppear {
            refreshLaunchAtLoginState()
        }
    }

    private var targetBrightnessSliderBinding: Binding<Double> {
        Binding {
            Double(model.targetBrightnessPercent)
        } set: { newValue in
            model.targetBrightnessPercent = Int(newValue.rounded())
        }
    }

    private var launchAtLoginBinding: Binding<Bool> {
        Binding {
            launchAtLoginState == .enabled
        } set: { isEnabled in
            setLaunchAtLoginEnabled(isEnabled)
        }
    }

    private func setLaunchAtLoginEnabled(_ isEnabled: Bool) {
        do {
            try launchAtLoginController.setEnabled(isEnabled)
            launchAtLoginError = nil
        } catch {
            launchAtLoginError = error.localizedDescription
        }

        refreshLaunchAtLoginState()
    }

    private func refreshLaunchAtLoginState() {
        launchAtLoginState = launchAtLoginController.state
    }
}
