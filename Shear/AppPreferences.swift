import Foundation

enum ShortcutModifier: String, CaseIterable {
    case control
    case command
    case function

    static let storageKey = "CutShortcutMode"
    static let defaultModifier: ShortcutModifier = .control

    var displayName: String {
        switch self {
        case .control:
            return "Control (^)"
        case .command:
            return "Command (⌘)"
        case .function:
            return "Fn / Globe (􀆪)"
        }
    }

    init(storedValue: String?) {
        guard let storedValue, let modifier = ShortcutModifier(rawValue: storedValue) else {
            self = ShortcutModifier.defaultModifier
            return
        }
        self = modifier
    }
}

enum AppWindowID {
    static let permissions = "permissions"
    static let settings = "settings"
    static let info = "info"
}

enum AppDefaultsKey {
    static let hideDockIcon = "HideDockIcon"
    static let hasShownPermissionsOnboarding = "HasShownPermissionsOnboarding"
}

enum AppPermission: CaseIterable, Hashable {
    case inputMonitoring
    case postEvents

    var title: String {
        switch self {
        case .inputMonitoring:
            return "Input Monitoring"
        case .postEvents:
            return "Accessibility"
        }
    }

    var subtitle: String {
        switch self {
        case .inputMonitoring:
            return "Required to detect your selected Finder shortcut globally."
        case .postEvents:
            return "Required to send Option+Command+V for Finder move-paste."
        }
    }

    var iconName: String {
        switch self {
        case .inputMonitoring:
            return "keyboard"
        case .postEvents:
            return "accessibility"
        }
    }

    func isGranted(in state: AppDelegate.PermissionState) -> Bool {
        switch self {
        case .inputMonitoring:
            return state.inputMonitoringGranted
        case .postEvents:
            return state.postEventAccessGranted
        }
    }
}

@MainActor
enum AppWindowRouter {
    private static var openWindowHandler: ((String) -> Void)?
    private static var pendingWindowID: String?

    static func install(handler: @escaping (String) -> Void) {
        openWindowHandler = handler
        if let pendingID = pendingWindowID {
            pendingWindowID = nil
            handler(pendingID)
        }
    }

    static func open(id: String) {
        if let openWindowHandler {
            openWindowHandler(id)
        } else {
            pendingWindowID = id
        }
    }
}
