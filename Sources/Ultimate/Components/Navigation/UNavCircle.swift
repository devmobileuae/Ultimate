import SwiftUI

/// Labeled circular nav / quick-action button (NavCircle.d.ts / `ult-navcircle`):
/// a 56pt icon circle with a caption (13) below. An optional coral count badge
/// pins to the top-trailing of the circle.
///
/// Tones: `.soft` (gray fill), `.dark` (inverse circle + onInverse icon),
/// `.white` (card fill + card shadow), `.candy(tone)` (tone fill + tone.onFill).
/// `selected` overrides the circle to a `surfaceInverse` fill with onInverse
/// content and bumps the label to primary/semibold (per `ult-navcircle` selected).
public struct UNavCircle: View {
    public enum Tone: Sendable { case soft, dark, white, candy(UTone) }

    private let icon: String
    private let label: String
    private let tone: Tone
    private let badge: Int?
    private let selected: Bool
    private let action: () -> Void

    public init(
        icon: String,
        label: String,
        tone: Tone = .soft,
        badge: Int? = nil,
        selected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.tone = tone
        self.badge = badge
        self.selected = selected
        self.action = action
    }

    private var circleFill: Color {
        if selected { return UColor.surfaceInverse }
        switch tone {
        case .soft: return UColor.surfaceFill
        case .dark: return UColor.surfaceInverse
        case .white: return UColor.surfaceCard
        case .candy(let t): return t.fill
        }
    }

    private var iconColor: Color {
        if selected { return UColor.textOnInverse }
        switch tone {
        case .soft, .white: return UColor.textPrimary
        case .dark: return UColor.textOnInverse
        case .candy(let t): return t.onFill
        }
    }

    private var castsShadow: Bool {
        if selected { return false }
        if case .white = tone { return true }
        return false
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: USpacing.s2) {
                UIcon(icon, size: 24)
                    .foregroundStyle(iconColor)
                    .frame(width: USize.controlLg, height: USize.controlLg)
                    .background {
                        if castsShadow {
                            Circle().fill(circleFill).uShadow(.card)
                        } else {
                            Circle().fill(circleFill)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if let badge {
                            UBadge(count: badge)
                                .offset(x: 4, y: -2)
                        }
                    }
                Text(label)
                    .uText(.caption)
                    .fontWeight(selected ? .semibold : .medium)
                    .foregroundStyle(selected ? UColor.textPrimary : UColor.textSecondary)
            }
        }
        .buttonStyle(.uPressable)
        .accessibilityLabel(label)
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }
}

/// Evenly-spaced row of ``UNavCircle`` buttons (Wallet's Add / Send / Request /
/// Bill). Each child stretches to an equal width so circles distribute evenly.
public struct UNavCircleRow<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: USpacing.s4) {
            content
                .frame(maxWidth: .infinity)
        }
    }
}
