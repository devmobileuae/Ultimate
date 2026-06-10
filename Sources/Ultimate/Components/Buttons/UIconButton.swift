import SwiftUI

/// Round icon-only button (IconButton.d.ts). Five variants, three sizes.
public enum UIconButtonVariant: CaseIterable, Sendable {
    case soft      // gray circle (default)
    case white     // card circle + card shadow
    case dark      // inverse circle — the signature arrow-up-right/check circle
    case outline   // hairline ring
    case ghost
}

public struct UIconButton: View {
    let icon: String
    let variant: UIconButtonVariant
    let size: UControlSize
    let label: String
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled

    public init(
        _ icon: String,
        variant: UIconButtonVariant = .soft,
        size: UControlSize = .md,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.size = size
        self.label = accessibilityLabel
        self.action = action
    }

    private var iconSize: CGFloat {
        switch size {
        case .sm: 16
        case .md: 18
        case .lg: 22
        }
    }

    private var background: Color {
        switch variant {
        case .soft: UColor.surfaceFill
        case .white: UColor.surfaceCard
        case .dark: UColor.surfaceInverse
        case .outline, .ghost: .clear
        }
    }
    private var foreground: Color {
        variant == .dark ? UColor.textOnInverse : UColor.textPrimary
    }

    public var body: some View {
        Button(action: action) {
            UIcon(icon, size: iconSize)
                .frame(width: size.height, height: size.height)
                .background {
                    if variant == .white {
                        Circle().fill(background).uShadow(.card)
                    } else {
                        Circle().fill(background)
                    }
                }
                .overlay {
                    if variant == .outline {
                        Circle().strokeBorder(UColor.borderHairline, lineWidth: USize.borderHairline)
                    }
                }
                .foregroundStyle(foreground)
                .opacity(isEnabled ? 1 : 0.4)
        }
        .buttonStyle(.uPressable)
        .accessibilityLabel(label)
    }
}
