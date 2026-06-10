import SwiftUI

/// Semantic colors. Every token resolves light/dark automatically.
public enum UColor {
    // MARK: Text
    public static let textPrimary = Color(light: UPalette.ink900, dark: 0xFFFFFF)
    public static let textSecondary = Color(light: UPalette.ink500, dark: UPalette.inkDark500)
    public static let textTertiary = Color(light: UPalette.ink400, dark: UPalette.inkDark400)
    public static let textDisabled = Color(light: UPalette.ink300, dark: UPalette.inkDark300)
    /// Content on `surfaceInverse` (white on ink in light; ink on white in dark).
    public static let textOnInverse = Color(light: 0xFFFFFF, dark: UPalette.ink900)
    /// Text on candy accent fills is always ink.
    public static let textOnAccent = Color(rgb: UPalette.ink900)
    /// Coral is the one accent that takes white (ink in dark, where lime leads).
    public static let textOnCoral = Color(light: 0xFFFFFF, dark: UPalette.ink900)

    // MARK: Surfaces
    public static let surfaceApp = Color(light: UPalette.paper, dark: UPalette.paperDark)
    public static let surfaceCard = Color(light: UPalette.card, dark: UPalette.cardDark)
    public static let surfaceSunken = Color(light: UPalette.sunken, dark: UPalette.sunkenDark)
    public static let surfaceFill = Color(light: UPalette.ink100, dark: UPalette.inkDark100)
    /// Primary buttons, toasts, action circles: ink in light, WHITE in dark.
    public static let surfaceInverse = Color(light: UPalette.ink900, dark: 0xFFFFFF)
    public static let scrim = Color(light: UIColor(rgb: 0x16171D, alpha: 0.4),
                                    dark: UIColor(rgb: 0x000000, alpha: 0.6))

    // MARK: Borders
    public static let borderHairline = Color(light: UPalette.ink200, dark: UPalette.inkDark200)
    public static let borderStrong = Color(light: UPalette.ink900, dark: 0xFFFFFF)

    // MARK: Accents
    /// The loud voice: coral in light, lime in dark. Max one moment per screen.
    public static let accentPrimary = Color(light: UPalette.coral500, dark: UPalette.lime500)
    public static let accentHighlight = Color(rgb: UPalette.amber500)

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
    public static let success = Color(rgb: UPalette.success)
    public static let warning = Color(rgb: UPalette.warning)
    public static let danger = Color(rgb: UPalette.danger)
    public static let info = Color(rgb: UPalette.peri500)

    // MARK: Control & interaction
    /// Selected fills (switch on, selected chip/segment/day): ink light, lime dark.
    public static let controlActive = Color(light: UPalette.ink900, dark: UPalette.lime500)
    public static let onControlActive = Color(light: 0xFFFFFF, dark: UPalette.ink900)
    /// Bottom nav pill is ink in BOTH themes.
    public static let navBackground = Color(rgb: UPalette.ink900)
    public static let navActive = Color(rgb: 0xFFFFFF)
    /// Faint ring lifting the nav pill off dark backgrounds (transparent in light).
    public static let navRing = Color(light: UIColor.clear,
                                      dark: UIColor(rgb: 0xFFFFFF, alpha: 0.1))
    public static let pressWash = Color(light: UIColor(rgb: 0x16171D, alpha: 0.06),
                                        dark: UIColor(rgb: 0xFFFFFF, alpha: 0.09))
    public static let dangerWash = Color(light: UIColor(rgb: UPalette.coral100),
                                         dark: UIColor(rgb: 0xE8552F, alpha: 0.16))
    public static let dangerWashStrong = Color(light: UIColor(rgb: UPalette.dangerWashStrongLight),
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
