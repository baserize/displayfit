import AppKit
import SwiftUI

struct KeyboardShortcutRecorder: View {
    let shortcut: AppKeyboardShortcut
    let onRecord: (AppKeyboardShortcut) -> Void
    let onInvalidShortcut: () -> Void

    @State private var isRecording = false

    var body: some View {
        Button {
            isRecording = true
        } label: {
            Text(isRecording ? L10n.string("settings.shortcut.recording") : shortcut.displayText)
                .font(.body.monospaced())
                .frame(minWidth: 96)
        }
        .buttonStyle(.bordered)
        .background {
            if isRecording {
                KeyboardShortcutCaptureView(
                    isRecording: $isRecording,
                    onRecord: onRecord,
                    onInvalidShortcut: onInvalidShortcut
                )
                .frame(width: 0, height: 0)
            }
        }
    }
}

private struct KeyboardShortcutCaptureView: NSViewRepresentable {
    @Binding var isRecording: Bool
    let onRecord: (AppKeyboardShortcut) -> Void
    let onInvalidShortcut: () -> Void

    func makeNSView(context: Context) -> KeyboardShortcutCaptureNSView {
        let view = KeyboardShortcutCaptureNSView()
        view.onRecord = { shortcut in
            onRecord(shortcut)
            isRecording = false
        }
        view.onCancel = {
            isRecording = false
        }
        view.onInvalidShortcut = onInvalidShortcut
        return view
    }

    func updateNSView(_ nsView: KeyboardShortcutCaptureNSView, context: Context) {
        nsView.onRecord = { shortcut in
            onRecord(shortcut)
            isRecording = false
        }
        nsView.onCancel = {
            isRecording = false
        }
        nsView.onInvalidShortcut = onInvalidShortcut

        if isRecording {
            DispatchQueue.main.async {
                nsView.window?.makeFirstResponder(nsView)
            }
        }
    }
}

private final class KeyboardShortcutCaptureNSView: NSView {
    var onRecord: ((AppKeyboardShortcut) -> Void)?
    var onCancel: (() -> Void)?
    var onInvalidShortcut: (() -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        handleKeyEvent(event)
        return true
    }

    override func keyDown(with event: NSEvent) {
        handleKeyEvent(event)
    }

    private func handleKeyEvent(_ event: NSEvent) {
        if event.keyCode == 53 {
            onCancel?()
            return
        }

        guard let shortcut = AppKeyboardShortcut(event: event) else {
            onInvalidShortcut?()
            return
        }

        onRecord?(shortcut)
    }
}
