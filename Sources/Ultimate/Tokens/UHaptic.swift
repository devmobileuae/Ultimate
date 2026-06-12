import SwiftUI
import UIKit

/// Haptic feedback styles for Ultimate's tappable elements.
public enum UHaptic: Sendable {
    case none
    case light, medium, heavy, soft, rigid       // impact
    case selection                                // selection change
    case success, warning, error                  // notification

    /// Fires the feedback. No-op for `.none`. System generators already
    /// respect the user's system-level haptics settings.
    @MainActor
    public func fire() {
        switch self {
        case .none:
            break
        case .light: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium: UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy: UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft: UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .rigid: UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .selection: UISelectionFeedbackGenerator().selectionChanged()
        case .success: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning: UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error: UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

/// Global haptics configuration — mirrors `UltimateTheme`.
/// Haptics are ON by default (`.light` on press). Disable app-wide with
/// `UltimateHaptics.configure(default: .none)`, or per-subtree with the
/// `.uHaptic(_:)` modifier.
public enum UltimateHaptics {
    private static let lock = NSLock()
    nonisolated(unsafe) private static var _default: UHaptic = .light

    public static var `default`: UHaptic {
        lock.lock(); defer { lock.unlock() }
        return _default
    }

    public static func configure(default haptic: UHaptic) {
        lock.lock(); defer { lock.unlock() }
        _default = haptic
    }
}

private struct UHapticKey: EnvironmentKey {
    static let defaultValue: UHaptic? = nil   // nil → UltimateHaptics.default
}

public extension EnvironmentValues {
    /// Per-subtree haptic override; `nil` falls back to `UltimateHaptics.default`.
    var uHaptic: UHaptic? {
        get { self[UHapticKey.self] }
        set { self[UHapticKey.self] = newValue }
    }
}

public extension View {
    /// Overrides the press haptic for Ultimate components in this subtree.
    func uHaptic(_ haptic: UHaptic) -> some View {
        environment(\.uHaptic, haptic)
    }
}

/// Internal helper: resolve and fire the effective press haptic.
@MainActor
func fireHaptic(_ override: UHaptic?) {
    (override ?? UltimateHaptics.default).fire()
}

/// Internal helper: fire a *semantic* haptic (e.g. `.selection`, `.warning`)
/// for state-changing controls. Honors only the on/off intent of the effective
/// press haptic — if that resolves to `.none`, fire nothing; otherwise fire the
/// requested semantic feedback regardless of the override's impact style.
@MainActor
func fireSemanticHaptic(_ semantic: UHaptic, override: UHaptic?) {
    guard (override ?? UltimateHaptics.default) != .none else { return }
    semantic.fire()
}
