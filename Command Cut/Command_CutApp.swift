import SwiftUI

@main
struct Command_CutApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @AppStorage("CutShortcutMode") private var shortcutMode = "command"
    @AppStorage("HideDockIcon") private var hideDockIcon = false
    @State private var launchAtLogin = false

    var body: some Scene {
        MenuBarExtra {
            MenuBarContent(
                appDelegate: appDelegate,
                shortcutMode: $shortcutMode,
                launchAtLogin: $launchAtLogin,
                hideDockIcon: $hideDockIcon
            )
        }
        label: {
            Image(systemName: "scissors")
                .imageScale(.medium)
        }

        Window("Info", id: "info") {
            InfoPopupView()
        }
        .defaultSize(width: 320, height: 220)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}

private struct MenuBarContent: View {
    let appDelegate: AppDelegate
    @Binding var shortcutMode: String
    @Binding var launchAtLogin: Bool
    @Binding var hideDockIcon: Bool
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Section("Shortcut Mode") {
            Button {
                shortcutMode = "command"
            } label: {
                ShortcutRow(title: "Command", shortcut: "⌘X", selected: shortcutMode == "command")
            }
            Button {
                shortcutMode = "control"
            } label: {
                ShortcutRow(title: "Control", shortcut: "⌃X", selected: shortcutMode == "control")
            }
        }

        Divider()

        Button {
            launchAtLogin.toggle()
            appDelegate.setLaunchAtLogin(launchAtLogin)
        } label: {
            Label("Launch at Login", systemImage: launchAtLogin ? "autostartstop" : "autostartstop.slash")
        }
        .onAppear {
            launchAtLogin = appDelegate.isLaunchAtLoginEnabled()
        }

        Button {
            hideDockIcon.toggle()
            appDelegate.setDockIconHidden(hideDockIcon)
        } label: {
            Label("Hide Dock Icon", systemImage: hideDockIcon ? "eye.slash" : "eye")
        }

        Divider()

        Button {
            appDelegate.openInputMonitoringSettings()
        } label: {
            Label("Input Monitoring Settings...", systemImage: "gear")
        }

        Button {
            openWindow(id: "info")
            NSApplication.shared.activate(ignoringOtherApps: true)
        } label: {
            Label("Info", systemImage: "info.circle")
        }

        Button {
            NSApplication.shared.terminate(nil)
        } label: {
            Label("Quit", systemImage: "xmark.circle")
        }
    }
}

private struct ShortcutRow: View {
    let title: String
    let shortcut: String
    let selected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .opacity(selected ? 1 : 0)
                .foregroundStyle(.secondary)
                .frame(width: 12)
            Text(title)
            Spacer()
            Text(shortcut)
                .foregroundStyle(.secondary)
        }
        .frame(minWidth: 200)
    }
}

private struct InfoPopupView: View {
    private let repositoryURL = URL(string: "https://github.com/flewgg/CommandCut")!
    private let creditsURL = URL(string: "https://github.com/vo1x")!

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Command Cut")
                .font(.headline)

            Text("Version \(appVersionDisplay)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            Link("GitHub Repository", destination: repositoryURL)

            HStack(spacing: 10) {
                Image("CreditsAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text("Aayush (vo1x)")
                    Link("github.com/vo1x", destination: creditsURL)
                        .font(.caption)
                }
                Spacer()
            }
        }
        .padding(16)
        .frame(minWidth: 220)
    }

    private var appVersionDisplay: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        switch (version, build) {
        case let (version?, build?) where version != build:
            return "\(version) (\(build))"
        case let (version?, _):
            return version
        case let (_, build?):
            return build
        default:
            return "Unknown"
        }
    }
}
