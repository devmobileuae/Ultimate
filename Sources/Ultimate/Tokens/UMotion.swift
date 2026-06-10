import SwiftUI

/// Motion tokens — quick, springy-but-subtle. No decorative loops anywhere.
public enum UMotion {
    public static let fast: TimeInterval = 0.14
    public static let base: TimeInterval = 0.22
    public static let slow: TimeInterval = 0.36

    /// cubic-bezier(0.22, 1, 0.36, 1)
    public static func easeOut(_ duration: TimeInterval = base) -> Animation {
        .timingCurve(0.22, 1, 0.36, 1, duration: duration)
    }
    /// cubic-bezier(0.34, 1.4, 0.64, 1) — switch thumbs, check pops.
    public static func spring(_ duration: TimeInterval = base) -> Animation {
        .timingCurve(0.34, 1.4, 0.64, 1, duration: duration)
    }
}

/// Standard press feedback: scale to 0.97 @ 140ms ease-out.
public struct UPressableStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(UMotion.easeOut(UMotion.fast), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == UPressableStyle {
    /// Press-scale feedback without any chrome.
    static var uPressable: UPressableStyle { UPressableStyle() }
}
