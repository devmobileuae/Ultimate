import SwiftUI
import UIKit

/// Semantic colors. Every token resolves light/dark automatically, and every
/// token consults the active ``UltimateTheme`` at draw time — configure a
/// ``UTheme`` once at app start to rebrand the whole system, or never touch
/// it and get stock Ultimate.
public enum UColor {
    /// A color that resolves theme overrides (then light/dark) at draw time.
    private static func themed(
        _ key: KeyPath<UTheme, UThemeColor?>,
        light: UIColor, dark: UIColor
    ) -> Color {
        Color(uiColor: UIColor { trait in
            let isDark = trait.userInterfaceStyle == .dark
            if let override = UltimateTheme.current[keyPath: key] {
                return override.resolve(dark: isDark)
            }
            return isDark ? dark : light
        })
    }

    private static func themed(
        _ key: KeyPath<UTheme, UThemeColor?>,
        light: UInt32, dark: UInt32
    ) -> Color {
        themed(key, light: UIColor(rgb: light), dark: UIColor(rgb: dark))
    }

    // MARK: Text
    public static let textPrimary = themed(\.textPrimary, light: UPalette.ink900, dark: 0xFFFFFF)
    public static let textSecondary = themed(\.textSecondary, light: UPalette.ink500, dark: UPalette.inkDark500)
    public static let textTertiary = themed(\.textTertiary, light: UPalette.ink400, dark: UPalette.inkDark400)
    public static let textDisabled = themed(\.textDisabled, light: UPalette.ink300, dark: UPalette.inkDark300)
    /// Content on `surfaceInverse` (white on ink in light; ink on white in dark).
    public static let textOnInverse = themed(\.textOnInverse, light: 0xFFFFFF, dark: UPalette.ink900)
    /// Text on candy accent fills is always ink.
    public static let textOnAccent = themed(\.textOnAccent, light: UPalette.ink900, dark: UPalette.ink900)
    /// Coral is the one accent that takes white (ink in dark, where lime leads).
    public static let textOnCoral = themed(\.textOnCoral, light: 0xFFFFFF, dark: UPalette.ink900)

    // MARK: Surfaces
    public static let surfaceApp = themed(\.surfaceApp, light: UPalette.paper, dark: UPalette.paperDark)
    public static let surfaceCard = themed(\.surfaceCard, light: UPalette.card, dark: UPalette.cardDark)
    public static let surfaceSunken = themed(\.surfaceSunken, light: UPalette.sunken, dark: UPalette.sunkenDark)
    public static let surfaceFill = themed(\.surfaceFill, light: UPalette.ink100, dark: UPalette.inkDark100)
    /// Primary buttons, toasts, action circles: ink in light, WHITE in dark.
    public static let surfaceInverse = themed(\.surfaceInverse, light: UPalette.ink900, dark: 0xFFFFFF)
    public static let scrim = themed(\.scrim,
                                     light: UIColor(rgb: 0x16171D, alpha: 0.4),
                                     dark: UIColor(rgb: 0x000000, alpha: 0.6))

    // MARK: Borders
    public static let borderHairline = themed(\.borderHairline, light: UPalette.ink200, dark: UPalette.inkDark200)
    public static let borderStrong = themed(\.borderStrong, light: UPalette.ink900, dark: 0xFFFFFF)

    // MARK: Accents
    /// The loud voice: coral in light, lime in dark. Max one moment per screen.
    public static let accentPrimary = themed(\.accentPrimary, light: UPalette.coral500, dark: UPalette.lime500)
    public static let accentHighlight = themed(\.accentHighlight, light: UPalette.amber500, dark: UPalette.amber500)

    // MARK: Candy palette (constant across themes; text on them is ink)
    public static let coral = Color(rgb: UPalette.coral500)
    public static let coralTint = Color(rgb: UPalette.coral100)
    public static let amber = Color(rgb: UPalette.amber500)
    public static let amberTint = Color(rgb: UPalette.amber100)
    public static let peri = Color(rgb: UPalette.peri500)
    public static let periTint = Color(rgb: UPalette.peri100)
    public static let lilac = Color(rgb: UPalette.lilac500)
    public static let lilacTint = Color(rgb: UPalette.lilac100)
    public static let pink = Color(rgb: UPalette.pink500)
    public static let pinkTint = Color(rgb: UPalette.pink100)
    public static let mint = Color(rgb: UPalette.mint500)
    public static let mintTint = Color(rgb: UPalette.mint100)
    public static let sky = Color(rgb: UPalette.sky500)
    public static let skyTint = Color(rgb: UPalette.sky100)
    public static let tangerine = Color(rgb: UPalette.tangerine500)
    public static let tangerineTint = Color(rgb: UPalette.tangerine100)
    public static let lime = Color(rgb: UPalette.lime500)
    public static let limeTint = Color(rgb: UPalette.lime100)

    // MARK: Status
    public static let success = themed(\.success, light: UPalette.success, dark: UPalette.success)
    public static let warning = themed(\.warning, light: UPalette.warning, dark: UPalette.warning)
    public static let danger = themed(\.danger, light: UPalette.danger, dark: UPalette.danger)
    public static let info = themed(\.info, light: UPalette.peri500, dark: UPalette.peri500)

    // MARK: Control & interaction
    /// Selected fills (switch on, selected chip/segment/day): ink light, lime dark.
    public static let controlActive = themed(\.controlActive, light: UPalette.ink900, dark: UPalette.lime500)
    public static let onControlActive = themed(\.onControlActive, light: 0xFFFFFF, dark: UPalette.ink900)
    /// Bottom nav pill is ink in BOTH themes.
    public static let navBackground = themed(\.navBackground, light: UPalette.ink900, dark: UPalette.ink900)
    public static let navActive = themed(\.navActive, light: 0xFFFFFF, dark: 0xFFFFFF)
    /// Faint ring lifting the nav pill off dark backgrounds (transparent in light).
    public static let navRing = themed(\.navRing,
                                       light: UIColor.clear,
                                       dark: UIColor(rgb: 0xFFFFFF, alpha: 0.1))
    public static let pressWash = themed(\.pressWash,
                                         light: UIColor(rgb: 0x16171D, alpha: 0.06),
                                         dark: UIColor(rgb: 0xFFFFFF, alpha: 0.09))
    public static let dangerWash = themed(\.dangerWash,
                                          light: UIColor(rgb: UPalette.coral100),
                                          dark: UIColor(rgb: 0xE8552F, alpha: 0.16))
    public static let dangerWashStrong = themed(\.dangerWashStrong,
                                                light: UIColor(rgb: UPalette.dangerWashStrongLight),
                                                dark: UIColor(rgb: 0xE8552F, alpha: 0.28))
}

/// Candy tone — used by Card, StatTile, Avatar, Calendar day fills, NavCircle.
public enum UTone: CaseIterable, Sendable {
    case coral, amber, peri, lilac, pink, mint, sky, tangerine, lime

    public var fill: Color {
        switch self {
        case .coral: UColor.coral; case .amber: UColor.amber
        case .peri: UColor.peri; case .lilac: UColor.lilac
        case .pink: UColor.pink; case .mint: UColor.mint
        case .sky: UColor.sky; case .tangerine: UColor.tangerine
        case .lime: UColor.lime
        }
    }
    public var tint: Color {
        switch self {
        case .coral: UColor.coralTint; case .amber: UColor.amberTint
        case .peri: UColor.periTint; case .lilac: UColor.lilacTint
        case .pink: UColor.pinkTint; case .mint: UColor.mintTint
        case .sky: UColor.skyTint; case .tangerine: UColor.tangerineTint
        case .lime: UColor.limeTint
        }
    }
    /// Text on a 500-level fill: ink everywhere except coral (white in light).
    public var onFill: Color { self == .coral ? UColor.textOnCoral : UColor.textOnAccent }
}
