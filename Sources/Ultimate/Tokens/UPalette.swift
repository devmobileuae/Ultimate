import UIKit

/// Raw palette. Internal — components and consumers use `UColor` semantics.
/// Generator-shaped: one constant per CSS custom property.
enum UPalette {
    // Ink scale — light theme values
    static let ink900: UInt32 = 0x16171D
    static let ink700: UInt32 = 0x3A3C46
    static let ink500: UInt32 = 0x6E707C
    static let ink400: UInt32 = 0x8D8F9A
    static let ink300: UInt32 = 0xB9BBC4
    static let ink200: UInt32 = 0xDCDDE2
    static let ink100: UInt32 = 0xEDEDF0

    // Ink scale — dark theme remap (dark.css)
    static let inkDark500: UInt32 = 0xA6AAB8
    static let inkDark400: UInt32 = 0x8A8E9C
    static let inkDark300: UInt32 = 0x4C505E
    static let inkDark200: UInt32 = 0x343845
    static let inkDark100: UInt32 = 0x262933

    // Surfaces
    static let paper: UInt32 = 0xF4F3EF
    static let card: UInt32 = 0xFFFFFF
    static let sunken: UInt32 = 0xEBEAE6
    static let paperDark: UInt32 = 0x0D0E12
    static let cardDark: UInt32 = 0x1A1C23
    static let sunkenDark: UInt32 = 0x07080A

    // Candy accents (identical in both themes)
    static let coral500: UInt32 = 0xE8552F;     static let coral100: UInt32 = 0xFADACE
    static let amber500: UInt32 = 0xF2C246;     static let amber100: UInt32 = 0xFBEAC2
    static let peri500: UInt32 = 0x8FA3EC;      static let peri100: UInt32 = 0xDDE4FB
    static let lilac500: UInt32 = 0xBFA8F3;     static let lilac100: UInt32 = 0xEBE3FC
    static let pink500: UInt32 = 0xF2A7DC;      static let pink100: UInt32 = 0xFBE2F3
    static let mint500: UInt32 = 0x9FD9A9;      static let mint100: UInt32 = 0xDFF3E2
    static let sky500: UInt32 = 0xA9D7F2;       static let sky100: UInt32 = 0xE2F1FB
    static let tangerine500: UInt32 = 0xF0973C; static let tangerine100: UInt32 = 0xFBE3C8
    static let lime500: UInt32 = 0xCDE94E;      static let lime100: UInt32 = 0xEEF7C8

    // Semantic
    static let success: UInt32 = 0x2E9E5B
    static let warning: UInt32 = 0xF0973C
    static let danger: UInt32 = 0xE0402A
    static let dangerWashStrongLight: UInt32 = 0xF6C8B8
}
