import SwiftUI

/// Pill button. Six voices, three sizes (Button.d.ts).
public enum UButtonVariant: CaseIterable, Sendable {
    case primary   // ink fill (white in dark), inverse text
    case accent    // coral (lime in dark) — the loud voice, max one per screen
    case soft      // gray fill
    case white     // card fill + whisper shadow (for colored/dark backdrops)
    case outline   // 1.5px strong border, transparent fill
    case ghost     // bare text
}

public struct UButton: View {
    let title: String
    let variant: UButtonVariant
    let size: UControlSize
    let icon: String?
    let iconRight: String?
    let block: Bool
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled

    public init(
        _ title: String,
        variant: UButtonVariant = .primary,
        size: UControlSize = .md,
        icon: String? = nil,
        iconRight: String? = nil,
        block: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.icon = icon
        self.iconRight = iconRight
        self.block = block
        self.action = action
    }

    private var iconSize: CGFloat { size == .sm ? 16 : 18 }
    private var fontSize: CGFloat { size == .sm ? 14 : size == .md ? 15 : 16 }

    private var background: Color {
        switch variant {
        case .primary: UColor.surfaceInverse
        case .accent: UColor.accentPrimary
        case .soft: UColor.surfaceFill
        case .white: UColor.surfaceCard
        case .outline, .ghost: .clear
        }
    }
    private var foreground: Color {
        switch variant {
        case .primary: UColor.textOnInverse
        case .accent: UColor.textOnCoral  // white-on-coral light; ink-on-lime dark
        case .soft, .white, .outline, .ghost: UColor.textPrimary
        }
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: USpacing.s2) {
                if let icon { UIcon(icon, size: iconSize) }
                Text(title).font(UFont.custom("SemiBold", size: fontSize))
                if let iconRight { UIcon(iconRight, size: iconSize) }
            }
            .padding(.horizontal, size == .sm ? USpacing.s4 : USpacing.s6)
            .frame(height: size.height)
            .frame(maxWidth: block ? .infinity : nil)
            .background {
                if variant == .white {
                    Capsule().fill(background).uShadow(.card)
                } else {
                    Capsule().fill(background)
                }
            }
            .overlay {
                if variant == .outline {
                    Capsule().strokeBorder(UColor.borderStrong, lineWidth: USize.borderStrong)
                }
            }
            .foregroundStyle(foreground)
            .opacity(isEnabled ? 1 : 0.4)
        }
        .buttonStyle(.uPressable)
    }
}
