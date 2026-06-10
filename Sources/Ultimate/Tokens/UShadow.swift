import SwiftUI

/// Elevation styles. Each is two stacked soft shadows (whisper aesthetic —
/// no inner shadows, no borders on cards).
public enum UShadow {
    case card, float, sheet
}

private struct UShadowModifier: ViewModifier {
    let shadow: UShadow
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        let ink = Color(rgb: 0x16171D)
        let black = Color.black
        switch (shadow, scheme) {
        case (.card, .light):
            content.shadow(color: ink.opacity(0.04), radius: 1, y: 1)
                   .shadow(color: ink.opacity(0.05), radius: 10, y: 6)
        case (.card, _):
            content.shadow(color: black.opacity(0.30), radius: 1, y: 1)
                   .shadow(color: black.opacity(0.35), radius: 10, y: 6)
        case (.float, .light):
            content.shadow(color: ink.opacity(0.12), radius: 6, y: 4)
                   .shadow(color: ink.opacity(0.16), radius: 20, y: 16)
        case (.float, _):
            content.shadow(color: black.opacity(0.40), radius: 6, y: 4)
                   .shadow(color: black.opacity(0.50), radius: 20, y: 16)
        case (.sheet, .light):
            content.shadow(color: ink.opacity(0.16), radius: 20, y: -8)
        case (.sheet, _):
            content.shadow(color: black.opacity(0.50), radius: 20, y: -8)
        }
    }
}

public extension View {
    func uShadow(_ shadow: UShadow) -> some View {
        modifier(UShadowModifier(shadow: shadow))
    }
}
