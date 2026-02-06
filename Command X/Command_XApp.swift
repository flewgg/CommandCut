import SwiftUI

@main
struct Command_XApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @AppStorage("CutShortcutMode") private var shortcutMode = "command"
    @State private var launchAtLogin = false

    var body: some Scene {
        MenuBarExtra("Command X", systemImage: "scissors") {
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
    }
}
