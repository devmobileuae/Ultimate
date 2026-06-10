import SwiftUI
import CoreText

/// One-time registration of the bundled Onest variable font.
public enum UFontRegistration {
    nonisolated(unsafe) private static var registered = false
    public static func registerIfNeeded() {
        guard !registered else { return }
        registered = true
        guard let url = Bundle.module.url(
            forResource: "Onest[wght]", withExtension: "ttf", subdirectory: "Fonts"
        ) else { assertionFailure("Onest font missing from bundle"); return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}

/// Ultimate type scale. Family: Onest (stand-in for the brand's Gilroy-like
/// face — swap point is the font name below). Sizes scale with Dynamic Type
/// via `relativeTo` anchors.
public enum UTextStyle: CaseIterable, Sendable {
    case display, title1, title2, title3, headline, body, label, caption, micro

    /// size / line-height multiplier / weight / tracking(em) / Dynamic Type anchor
    var spec: (size: CGFloat, lh: CGFloat, weight: String, tracking: CGFloat, anchor: Font.TextStyle) {
        switch self {
        case .display:  (40, 1.08, "Bold",     -0.02, .largeTitle)
        case .title1:   (30, 1.15, "Bold",     -0.01, .title)
        case .title2:   (24, 1.20, "Bold",     -0.01, .title2)
        case .title3:   (20, 1.25, "SemiBold", -0.01, .title3)
        case .headline: (17, 1.30, "SemiBold",  0,    .headline)
        case .body:     (16, 1.45, "Regular",   0,    .body)
        case .label:    (14, 1.35, "Medium",    0,    .subheadline)
        case .caption:  (13, 1.30, "Medium",    0,    .caption)
        case .micro:    (11, 1.20, "Bold",      0,    .caption2)
        }
    }

    public var font: Font {
        UFontRegistration.registerIfNeeded()
        let s = spec
        return .custom("Onest-\(s.weight)", size: s.size, relativeTo: s.anchor)
    }
    /// Extra line spacing to approximate the CSS line-height.
    public var lineSpacing: CGFloat { let s = spec; return max(0, s.size * (s.lh - 1.15)) }
    public var tracking: CGFloat { spec.tracking * spec.size }
}

public enum UFont {
    public static var display: Font { UTextStyle.display.font }
    public static var title1: Font { UTextStyle.title1.font }
    public static var title2: Font { UTextStyle.title2.font }
    public static var title3: Font { UTextStyle.title3.font }
    public static var headline: Font { UTextStyle.headline.font }
    public static var body: Font { UTextStyle.body.font }
    public static var label: Font { UTextStyle.label.font }
    public static var caption: Font { UTextStyle.caption.font }
    public static var micro: Font { UTextStyle.micro.font }
    /// Onest at arbitrary size/weight ("Regular"|"Medium"|"SemiBold"|"Bold").
    public static func custom(_ weight: String, size: CGFloat) -> Font {
        UFontRegistration.registerIfNeeded()
        return .custom("Onest-\(weight)", size: size)
    }
}

public extension View {
    /// Applies an Ultimate text style: font + tracking + line spacing.
    func uText(_ style: UTextStyle) -> some View {
        font(style.font).tracking(style.tracking).lineSpacing(style.lineSpacing)
    }
}
