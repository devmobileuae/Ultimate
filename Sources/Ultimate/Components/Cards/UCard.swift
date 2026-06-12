import SwiftUI

/// Base card (`ult-card`): radius xl 28, 20pt padding, whisper card shadow, no border.
///
/// Optional candy fill instead of card white:
/// - `.tone(_)` — bold 500 fill, content defaults to the tone's `onFill` ink/white;
/// - `.tint(_)` — pastel 100 fill, content reads in ink in both themes.
///
/// Per `ult-card` CSS the toned variants drop the whisper shadow (only the plain
/// white card carries `--shadow-card`); only `.card` keeps elevation.
/// Card fill — shared by every card-shaped component.
public enum UCardFill: Sendable {
    case card
    case tone(UTone)
    case tint(UTone)
    /// Frosted glass — material + tint + rim + highlight, no shadow. Best over
    /// colorful or photographic backdrops (see ``View/uGlass(radius:)``).
    case glass
}

public struct UCard<Content: View>: View {
    public typealias Fill = UCardFill

    private let fill: Fill
    private let content: Content

    public init(fill: Fill = .card, @ViewBuilder content: () -> Content) {
        self.fill = fill
        self.content = content()
    }

    private var foreground: Color {
        switch fill {
        case .card: UColor.textPrimary
        case .tone(let t): t.onFill
        case .tint: UColor.textOnAccent  // ink, constant across themes
        case .glass: UColor.textPrimary
        }
    }

    private var hasShadow: Bool {
        if case .card = fill { return true }
        return false
    }

    private let shape = RoundedRectangle(cornerRadius: URadius.xl, style: .continuous)

    @ViewBuilder private var cardBackground: some View {
        switch fill {
        case .card: shape.fill(UColor.surfaceCard)
        case .tone(let t): shape.fill(t.fill)
        case .tint(let t): shape.fill(t.tint)
        case .glass: glassBackground(shape)
        }
    }

    public var body: some View {
        content
            .padding(USpacing.s5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background { cardBackground }
            .clipShape(shape)
            .foregroundStyle(foreground)
            .modifier(OptionalCardShadow(enabled: hasShadow))
    }
}

private struct OptionalCardShadow: ViewModifier {
    let enabled: Bool
    func body(content: Content) -> some View {
        if enabled { content.uShadow(.card) } else { content }
    }
}
