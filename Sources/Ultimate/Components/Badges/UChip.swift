import SwiftUI

/// 34pt pill chip (Chip.d.ts / `ult-chip`): filter rows, meta tags.
///
/// `selected` overrides any variant with a `controlActive` fill and
/// `onControlActive` text. Tappable chips (non-nil `action`) get press-scale
/// feedback via `.uPressable`.
public struct UChip: View {
    public enum Variant { case soft, outline, white }

    private let text: String
    private let icon: String?
    private let variant: Variant
    private let selected: Bool
    private let action: (() -> Void)?

    public init(
        _ text: String,
        icon: String? = nil,
        variant: Variant = .soft,
        selected: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.variant = variant
        self.selected = selected
        self.action = action
    }

    private var background: Color {
        if selected { return UColor.controlActive }
        switch variant {
        case .soft: return UColor.surfaceFill
        case .outline: return .clear
        case .white: return UColor.surfaceCard
        }
    }

    private var foreground: Color {
        selected ? UColor.onControlActive : UColor.textPrimary
    }

    // Outline ring only when not selected; `ult-chip--outline` uses the strong
    // border width with the hairline color.
    private var showsRing: Bool { variant == .outline && !selected }

    @ViewBuilder private var content: some View {
        HStack(spacing: 6) {
            if let icon {
                UIcon(icon, size: 16)
            }
            Text(text).uText(.label)
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, USpacing.s4)
        .frame(height: 34)
        .background(Capsule().fill(background))
        .overlay {
            if showsRing {
                Capsule().strokeBorder(UColor.borderHairline, lineWidth: USize.borderStrong)
            }
        }
        .contentShape(.capsule)
    }

    public var body: some View {
        if let action {
            Button(action: action) { content }
                .buttonStyle(.uPressable)
                .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
        } else {
            content
        }
    }
}
