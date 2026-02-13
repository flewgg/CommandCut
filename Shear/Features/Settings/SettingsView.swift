import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    let appDelegate: AppDelegate
    @AppStorage(ShortcutModifier.storageKey) private var shortcutModeRawValue = ShortcutModifier.defaultModifier.rawValue
    @State private var launchAtLogin = false
    @State private var hideDockIcon = false
    @State private var permissions = AppDelegate.PermissionState(
        inputMonitoringGranted: false,
        postEventAccessGranted: false
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Modifier Key")
                Spacer()
                Picker("Modifier Key", selection: shortcutModeBinding) {
                    ForEach(ShortcutModifier.allCases, id: \.self) { modifier in
                        Text(modifier.displayName).tag(modifier)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(width: 170)
            }

            SettingsToggleRow(title: "Hide Dock Icon", isOn: dockIconToggleBinding)
            SettingsToggleRow(title: "Launch at Startup", isOn: launchAtLoginToggleBinding)

            if ShortcutModifier(storedValue: shortcutModeRawValue) == .command {
                Text("Command mode may override Finder text cut behavior.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            ForEach(AppPermission.allCases, id: \.self) { permission in
                permissionRow(permission)
            }

            HStack {
                Spacer()
                Button("Refresh Permission Status") {
                    refreshPermissions()
                }
            }
        }
        .padding(18)
        .frame(minWidth: 440)
        .onAppear(perform: refreshPermissions)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active { refreshPermissions() }
        }
    }

    private var shortcutModeBinding: Binding<ShortcutModifier> {
        rawValueBinding(
            rawValue: $shortcutModeRawValue,
            defaultValue: ShortcutModifier.defaultModifier
        )
    }

    private var launchAtLoginToggleBinding: Binding<Bool> {
        syncedToggleBinding(
            state: $launchAtLogin,
            apply: { desiredState in
                _ = appDelegate.setLaunchAtLogin(desiredState)
            },
            read: appDelegate.isLaunchAtLoginEnabled
        )
    }

    private var dockIconToggleBinding: Binding<Bool> {
        syncedToggleBinding(
            state: $hideDockIcon,
            apply: appDelegate.setDockIconHidden,
            read: appDelegate.isDockIconHidden
        )
    }

    private func rawValueBinding<Value: RawRepresentable>(
        rawValue: Binding<String>,
        defaultValue: Value
    ) -> Binding<Value> where Value.RawValue == String {
        Binding(
            get: { Value(rawValue: rawValue.wrappedValue) ?? defaultValue },
            set: { rawValue.wrappedValue = $0.rawValue }
        )
    }

    private func syncedToggleBinding(
        state: Binding<Bool>,
        apply: @escaping (Bool) -> Void,
        read: @escaping () -> Bool
    ) -> Binding<Bool> {
        Binding(
            get: { state.wrappedValue },
            set: { desiredState in
                apply(desiredState)
                state.wrappedValue = read()
            }
        )
    }

    private func permissionRow(_ permission: AppPermission) -> some View {
        let granted = permission.isGranted(in: permissions)
        return HStack(spacing: 8) {
            Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(granted ? Color.green : Color.orange)
            Text(permission.title)
            Text(granted ? "Granted" : "Missing")
                .foregroundStyle(.secondary)
            Button {
                showPermissionInfo(permission.subtitle)
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            Spacer()
            Button("Open System Settings…") {
                appDelegate.openSettings(for: permission)
            }
        }
    }

    private func showPermissionInfo(_ details: String) {
        let alert = NSAlert()
        alert.messageText = "Why this permission is needed"
        alert.informativeText = details
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    private func refreshFromSystem() {
        launchAtLogin = appDelegate.isLaunchAtLoginEnabled()
        hideDockIcon = appDelegate.isDockIconHidden()
        permissions = appDelegate.permissionState()
    }

    private func refreshPermissions() {
        appDelegate.refreshPermissionState()
        refreshFromSystem()
    }
}

private struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
    }
}
