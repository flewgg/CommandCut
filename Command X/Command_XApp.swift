import SwiftUI
import Combine

@main
struct Command_XApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @AppStorage("CutShortcutMode") private var shortcutMode = "command"
    @State private var launchAtLogin = false
    @StateObject private var cutMode = CutModeObserver()

    var body: some Scene {
        MenuBarExtra {
            Section("Shortcut Mode") {
                Button {
                    shortcutMode = "command"
                } label: {
                    HStack {
                        Text("Command")
                        Spacer()
                        Text("⌘X")
                            .foregroundStyle(.secondary)
                        if shortcutMode == "command" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button {
                    shortcutMode = "control"
                } label: {
                    HStack {
                        Text("Control")
                        Spacer()
                        Text("⌃X")
                            .foregroundStyle(.secondary)
                        if shortcutMode == "control" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            Divider()

            Toggle("Launch at Login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { _, newValue in
                    appDelegate.setLaunchAtLogin(newValue)
                }
                .onAppear {
                    launchAtLogin = appDelegate.isLaunchAtLoginEnabled()
                }

            Divider()

           
            Button("Input Monitoring Settings...") {
                appDelegate.openInputMonitoringSettings()
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        label: {
            Image(systemName: "scissors")
                .imageScale(.medium)
        }
    }
}

final class CutModeObserver: ObservableObject {
    @Published var active = false
    private var observer: NSObjectProtocol?

    init() {
        observer = NotificationCenter.default.addObserver(
            forName: .commandXCutModeChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let active = notification.userInfo?["active"] as? Bool {
                self?.active = active
            }
        }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
