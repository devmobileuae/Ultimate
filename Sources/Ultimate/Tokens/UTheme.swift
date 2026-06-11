import SwiftUI
import UIKit

/// One themable color: a light/dark pair of hex values.
///
/// ```swift
/// UThemeColor(light: 0xC44569, dark: 0xE58BA3)   // different per scheme
/// UThemeColor(0xC44569)                          // same in both schemes
/// ```
public struct UThemeColor: Sendable {
    let lightRGB: UInt32
    let lightAlpha: CGFloat
    let darkRGB: UInt32
    let darkAlpha: CGFloat

    public init(light: UInt32, dark: UInt32,
                lightAlpha: CGFloat = 1, darkAlpha: CGFloat = 1) {
        self.lightRGB = light
        self.lightAlpha = lightAlpha
        self.darkRGB = dark
        self.darkAlpha = darkAlpha
    }

    /// Same color in both schemes.
    public init(_ both: UInt32, alpha: CGFloat = 1) {
        self.init(light: both, dark: both, lightAlpha: alpha, darkAlpha: alpha)
    }

    func resolve(dark: Bool) -> UIColor {
        dark ? UIColor(rgb: darkRGB, alpha: darkAlpha)
             : UIColor(rgb: lightRGB, alpha: lightAlpha)
    }
}

/// Overrides for Ultimate's semantic colors. Every field is optional —
/// `nil` keeps the built-in Ultimate value, so an empty `UTheme()` is exactly
/// the stock design system.
///
/// Apply once at app start (before the first view renders):
///
/// ```swift
/// @main struct MyApp: App {
///     init() {
///         UltimateTheme.configure(UTheme(
///             accentPrimary: .init(light: 0xC44569, dark: 0xE58BA3),
///             controlActive: .init(light: 0xC44569, dark: 0xE58BA3),
///             onControlActive: .init(light: 0xFFFFFF, dark: 0x121020)
///         ))
///     }
///     ...
/// }
/// ```
///
/// The theme may also be re-applied at runtime; views pick the new values up
/// on their next render (colors resolve the active theme at draw time).
public struct UTheme: Sendable {
    // MARK: Text
    public var textPrimary: UThemeColor?
    public var textSecondary: UThemeColor?
    public var textTertiary: UThemeColor?
    public var textDisabled: UThemeColor?
    public var textOnInverse: UThemeColor?
    public var textOnAccent: UThemeColor?
    public var textOnCoral: UThemeColor?

    // MARK: Surfaces
    public var surfaceApp: UThemeColor?
    public var surfaceCard: UThemeColor?
    public var surfaceSunken: UThemeColor?
    public var surfaceFill: UThemeColor?
    public var surfaceInverse: UThemeColor?
    public var scrim: UThemeColor?

    // MARK: Borders
    public var borderHairline: UThemeColor?
    public var borderStrong: UThemeColor?

    // MARK: Accents
    public var accentPrimary: UThemeColor?
    public var accentHighlight: UThemeColor?

    // MARK: Status
    public var success: UThemeColor?
    public var warning: UThemeColor?
    public var danger: UThemeColor?
    public var info: UThemeColor?

    // MARK: Control & interaction
    public var controlActive: UThemeColor?
    public var onControlActive: UThemeColor?
    public var navBackground: UThemeColor?
    public var navActive: UThemeColor?
    public var navRing: UThemeColor?
    public var pressWash: UThemeColor?
    public var dangerWash: UThemeColor?
    public var dangerWashStrong: UThemeColor?

    public init(
        textPrimary: UThemeColor? = nil,
        textSecondary: UThemeColor? = nil,
        textTertiary: UThemeColor? = nil,
        textDisabled: UThemeColor? = nil,
        textOnInverse: UThemeColor? = nil,
        textOnAccent: UThemeColor? = nil,
        textOnCoral: UThemeColor? = nil,
        surfaceApp: UThemeColor? = nil,
        surfaceCard: UThemeColor? = nil,
        surfaceSunken: UThemeColor? = nil,
        surfaceFill: UThemeColor? = nil,
        surfaceInverse: UThemeColor? = nil,
        scrim: UThemeColor? = nil,
        borderHairline: UThemeColor? = nil,
        borderStrong: UThemeColor? = nil,
        accentPrimary: UThemeColor? = nil,
        accentHighlight: UThemeColor? = nil,
        success: UThemeColor? = nil,
        warning: UThemeColor? = nil,
        danger: UThemeColor? = nil,
        info: UThemeColor? = nil,
        controlActive: UThemeColor? = nil,
        onControlActive: UThemeColor? = nil,
        navBackground: UThemeColor? = nil,
        navActive: UThemeColor? = nil,
        navRing: UThemeColor? = nil,
        pressWash: UThemeColor? = nil,
        dangerWash: UThemeColor? = nil,
        dangerWashStrong: UThemeColor? = nil
    ) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textDisabled = textDisabled
        self.textOnInverse = textOnInverse
        self.textOnAccent = textOnAccent
        self.textOnCoral = textOnCoral
        self.surfaceApp = surfaceApp
        self.surfaceCard = surfaceCard
        self.surfaceSunken = surfaceSunken
        self.surfaceFill = surfaceFill
        self.surfaceInverse = surfaceInverse
        self.scrim = scrim
        self.borderHairline = borderHairline
        self.borderStrong = borderStrong
        self.accentPrimary = accentPrimary
        self.accentHighlight = accentHighlight
        self.success = success
        self.warning = warning
        self.danger = danger
        self.info = info
        self.controlActive = controlActive
        self.onControlActive = onControlActive
        self.navBackground = navBackground
        self.navActive = navActive
        self.navRing = navRing
        self.pressWash = pressWash
        self.dangerWash = dangerWash
        self.dangerWashStrong = dangerWashStrong
    }
}

/// Holds the active theme. `UColor` tokens resolve against it at draw time,
/// so a theme configured at app start applies everywhere with no further
/// plumbing, and a theme re-applied at runtime shows up on the next render.
public enum UltimateTheme {
    private static let lock = NSLock()
    nonisolated(unsafe) private static var _current = UTheme()

    /// The active theme. Empty (`UTheme()`) by default — stock Ultimate.
    public static var current: UTheme {
        lock.lock(); defer { lock.unlock() }
        return _current
    }

    /// Installs a theme. Call once at app start for static branding, or
    /// re-call at runtime (e.g. on a mode change) — views adopt the new
    /// values on their next render.
    public static func configure(_ theme: UTheme) {
        lock.lock(); defer { lock.unlock() }
        _current = theme
    }

    /// Restores the stock Ultimate look.
    public static func reset() { configure(UTheme()) }
}
